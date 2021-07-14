extends Control


var success : bool = false
var embed
var typecolor : String
var responses = [
	"Kittea showed you a picture.",
	"Kittea found something!",
	"Kittea's yawn conjured an image.",
	"Kittea coughed up something..."
]
var comments = [
	["How cute.","It was kind of dusty.","Mint as a fresh dollar bill.","Where'd she find this?"],
	["It's an image.","It's her scribbles.","That was fast.","Kittea wants to be petted."],
	["How did she do that?!","Like Candlesmith, like Kittea.","How does that even work?","Maybe these are her thoughts."],
	["Ew, gross.","...That's not a hairball.", "Kittea sniffed in disgust.", "When did she swallow this...?"]
]

func gen_card(dataName):
	$View.set_size(Vector2(480,480))
	randomize()
	var cardData = load("res://Scenes/Datacard.tscn").instance()
	$View.add_child(cardData)
	success = cardData.materialize(dataName)
	yield(VisualServer, "frame_post_draw")
	var image = $View.get_texture().get_data()
	image.flip_y()
	image.convert(Image.FORMAT_RGBA8)
	image.save_png("user://goomble_card.png")
	if dataName.to_lower() == "kittea":
		construct_embed(typecolor,"Kittea puffed up with pride.","I think she wants a headpat.")
	else:
		var temp = randi() % 4
		construct_embed(typecolor,responses[temp],comments[temp][randi()%4])
	if success:
		Global.header = ["Content-Type: multipart/form-data;boundary=\"KitteaBoundary\""]
	else:
		Global.header = ["Content-Type: application/json"]
	Global.passthrough = success
	return embed if success else {"content" : Global.cats["angry cat"] + "  No such goomble exists!"}


func gen_move_card(dataName):
	$View.set_size(Vector2(480,208))
	var moveData = load("res://Scenes/DataMove.tscn").instance()
	$View.add_child(moveData)
	success = moveData.materialize(dataName)
	yield(VisualServer, "frame_post_draw")
	var image = $View.get_texture().get_data()
	image.flip_y()
	image.convert(Image.FORMAT_RGBA8)
	image.save_png("user://goomble_card.png")
	if success:
		Global.header = ["Content-Type: multipart/form-data;boundary=\"KitteaBoundary\""]
	else:
		Global.header = ["Content-Type: application/json"]
	Global.passthrough = success
	construct_embed_card(typecolor,dataName)
	return embed if success else {"content" : Global.cats["sad cat"] + "  Kittea does not recognize that move..."}


func construct_embed(hexcolor : String, message, comment):
	var embed_img = File.new()
	embed_img.open('user://goomble_card.png', File.READ)
	var img_bytes = embed_img.get_buffer(embed_img.get_len())
	embed = "\r\n--KitteaBoundary\r\n"+\
		"Content-Disposition: form-data; name=\"payload_json\"\r\n"+\
		"Content-Type: application/json\r\n\r\n"+\
		"{\"embeds\": [\r\n\t{"+\
		"\r\n\t\t\"title\":\"" + message + "\","+\
		"\r\n\t\t\"description\":\"" + comment + "\","+\
		"\r\n\t\t\"color\":"+str(hexcolor.hex_to_int())+","+\
		"\r\n\t\t\"image\":{\"url\":\"attachment://goomble_card.png\"}\r\n\t}]}"+\
		"\r\n--KitteaBoundary\r\n"+\
		"Content-Disposition: form-data; name=\"goomble_card\"; filename=\"goomble_card.png\"\r\n"+\
		"Content-Transfer-Encoding: base64\r\n"+\
		"Content-Type: image/png\r\n\r\n"+str(Marshalls.raw_to_base64(img_bytes))+\
		"\r\n--KitteaBoundary--\r\n"


func construct_embed_card(hexcolor : String, dName : String):
	var embed_img = File.new()
	embed_img.open('user://goomble_card.png', File.READ)
	var img_bytes = embed_img.get_buffer(embed_img.get_len())
	embed = "\r\n--KitteaBoundary\r\n"+\
		"Content-Disposition: form-data; name=\"payload_json\"\r\n"+\
		"Content-Type: application/json\r\n\r\n"+\
		"{\"embeds\": [\r\n\t{"+\
		"\r\n\t\t\"color\":"+str(hexcolor.hex_to_int())+","+\
		"\r\n\t\t\"image\":{\"url\":\"attachment://goomble_card.png\"}\r\n\t}]}"+\
		"\r\n--KitteaBoundary\r\n"+\
		"Content-Disposition: form-data; name=\"goomble_card\"; filename=\"goomble_card.png\"\r\n"+\
		"Content-Transfer-Encoding: base64\r\n"+\
		"Content-Type: image/png\r\n\r\n"+str(Marshalls.raw_to_base64(img_bytes))+\
		"\r\n--KitteaBoundary--\r\n"


func set_color(hex):
	typecolor = hex
