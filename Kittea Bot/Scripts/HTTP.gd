extends HTTPRequest


var discord_url : String = "wss://gateway.discord.gg/?v=6&encoding=json"
var file_path : String = "user://oauth.gg2"
var oauth : String
var session_id : String
var client : WebSocketClient
var last_sequence : float
var ping_interval : float
var heartbeat_ack_received : bool = true
var invalid_session_resumable : bool
var headers
var channel_id
var maindict

onready var clock = $pingTimer
onready var invalid_clock = $invalidTimer
onready var cdr_clock = $cooldownTimer
onready var cmdList = preload("res://Scripts/Commands.gd").new()


func _ready() -> void:
	add_to_group("httpcall")
	add_child(cmdList)
	oauth = load_key()
	randomize()
	client = WebSocketClient.new()
	client.connect_to_url(discord_url)
	client.connect("connection_established", self, "_on_connected")
	client.connect("data_received", self, "_on_data_received")
	client.connect("connection_closed", self, "_connection_closed")
	client.connect("server_close_request", self, "_server_close_request")
	clock.connect("timeout", self, "_on_pingTimer_timeout")
	invalid_clock.connect("timeout", self, "_on_invalid_Timer_timeout")


func _process(_delta : float) -> void:
	if client.get_connection_status() != NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
		client.poll()
	else:
		client.connect_to_url(discord_url)


func _on_connected(protocol : String) -> void:
	print("Connection Established! Protocol: " + protocol)


func _on_data_received() -> void:
	var packet := client.get_peer(1).get_packet()
	var data := packet.get_string_from_utf8()
	var json_parsed := JSON.parse(data)
	maindict = json_parsed.result
	var op := str(maindict["op"])
	print(op)
	match op:
		"0": #Opcode 0 (Events)
			handle_events(maindict)
		"9": #Opcode 9 Invalid session
			invalid_session_resumable = maindict["d"]
			invalid_clock.one_shot = true
			invalid_clock.wait_time = rand_range(1,5)
			invalid_clock.start()
		"10": #Opcode 10 Hello
			#Establish ping
			ping_interval = maindict["d"]["heartbeat_interval"]
			clock.wait_time = ping_interval / 1000
			clock.start()
			#Return Opcode 2 Identify to Gateway
			var gen : Dictionary = {}
			if !session_id:
				gen = gen_dict(2, {"token" : oauth, "properties": {}})
			else:
				gen = gen_dict(6, {"token" : oauth, "session_id" : session_id, "seq" : last_sequence})
			send_dict_as_packet(gen)
		"11": #Opcode 11 Heartbeat ACK
			heartbeat_ack_received = true
			print("Received ACK from Gateway.")


func _on_pingTimer_timeout() -> void:
	send_dict_as_packet(gen_dict(1, last_sequence))
	heartbeat_ack_received = false
	print("Sent ping to gateway.")


func send_dict_as_packet(d : Dictionary) -> void:
	var query = to_json(d)
	client.get_peer(1).put_packet(query.to_utf8())


func handle_events(dict : Dictionary):
	last_sequence = dict["s"]
	var event_name : String = dict["t"]
	print(event_name)
	match event_name:
		"READY":
			session_id = dict["d"]["session_id"]
		"MESSAGE_CREATE":
			Global.passthrough = false
			headers = ["Authorization: Bot %s" % oauth]
			channel_id = dict["d"]["channel_id"]
			var message_content = dict["d"]["content"]
			var reply = cmdList.scan_message(message_content,cdr_clock.get_time_left())
			if reply is GDScriptFunctionState: # Still working.
				reply = yield(reply, "completed")
			if !reply.empty():
				headers.append_array(Global.header)
				var query : String = JSON.print(reply) if !Global.passthrough else reply
				request("https://discordapp.com/api/v6/channels/%s/messages" % channel_id, headers, true, HTTPClient.METHOD_POST, query)
				cdr_clock.one_shot = true
				cdr_clock.wait_time = 3
				cdr_clock.start()


func _on_invalid_Timer_timeout() -> void:
	var gen : Dictionary 
	if invalid_session_resumable && session_id:
		gen = gen_dict(6, {"token" : oauth, "session_id" : session_id, "seq" : last_sequence})
	else:
		gen =  gen_dict(2, {"token" : oauth, "properties" : {}})
	send_dict_as_packet(gen)


func _connection_closed(was_clean_close : bool) -> void:
	print("Disconnected. Clean close: %s" % was_clean_close)


func _server_close_request(code : int, reason : String) -> void:
	print("Server requested a clean close. Code: %s, reason: %s" % [code, reason])


func gen_dict(opcode : int, extra_perms) -> Dictionary:
	var dict : Dictionary = {}
	dict["op"] = opcode
	dict["d"] = extra_perms
	return dict


func load_key() -> String:
	var authkey = File.new()
	if authkey.file_exists(file_path):
		var data : String
		authkey.open(file_path,File.READ)
		data = authkey.get_line()
		authkey.close()
		return data
	else:
		return ""


func replace_header(entry):
	print("FIRST: "+str(entry))
	headers = ["Authorization: Bot %s" % oauth, entry[0]]
