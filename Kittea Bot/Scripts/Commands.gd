extends Node


var prefix = "GG2."
var args : Dictionary = {
	"INFO" : funcref(self,"cmd_info"),
	"SLEEP" : funcref(self,"cmd_sleep"),
	"MOVE" : funcref(self,"cmd_move"),
	"KITTEA" : funcref(self,"cmd_kittea"),
	"BUG" : funcref(self,"cmd_report"),
	}


func construct_message(input):
	var message = {}
	


func is_prefix(message : String) -> bool:
	var splitter : Array = [message.substr(0,prefix.length()), message.substr(prefix.length(),-1)]
	return splitter[0] == prefix


func is_args(message : String) -> bool:
	var substring : String = message.substr(prefix.length(),-1)
	return false if substring.empty() else args.keys().has(substring.split(" ",true,1)[0].to_upper())


func scan_message(message : String, timer : float) -> Dictionary:
	if is_prefix(message):
		if int(timer) == 0:
			if is_args(message):
				var substring : String = message.substr(prefix.length(),-1)
				var cmd_arg : String = substring.split(" ",true,1)[0].to_upper()
				if substring.split(" ",true,1).size() > 1:
					var cmd_params : String = substring.split(" ",true,1)[1]
					var returnData = args[cmd_arg].call_funcv([cmd_params])
					if returnData is GDScriptFunctionState:
						returnData = yield(returnData, "completed")
					return returnData
				else:
					Global.header = ["Content-Type: application/json"]
					return {"content" : (Global.cats["angry cat"] + "   Kittea expected more!")}
			else:
				Global.header = ["Content-Type: application/json"]
				return {"content" : (Global.cats["sad cat"] + "   Kittea could not understand...")}
		else: 
			Global.header = ["Content-Type: application/json"]
			return {"content" : (Global.cats["angry cat"] + "   Rowr, please wait!")}
	return {}


func cmd_info(name : String) -> Dictionary:
	var tempData = get_tree().get_root().get_node("Core").call("create_img", name)
	if tempData is GDScriptFunctionState:
		tempData = yield(tempData, "completed")
	return tempData


func cmd_move(name : String) -> Dictionary:
	var tempData = get_tree().get_root().get_node("Core").call("create_move", name)
	if tempData is GDScriptFunctionState:
		tempData = yield(tempData, "completed")
	return tempData


func cmd_sleep(timed : String) -> Dictionary:
	Global.header = ["Content-Type: application/json"]
	if verifyUser():
		Global.sleepcounter = int(timed) * 60
		return {"content" : (Global.cats["purr cat"] + "   Kittea will go to sleep in "+ timed +" seconds.")}
	else:
		return {"content" : (Global.cats["purr cat"] + "   Kittea yawned.")}


func cmd_kittea(pat : String) -> Dictionary:
	Global.header = ["Content-Type: application/json"]
	if pat == "headpat":
		return {"content" : Global.pixelCat}
	else:
		return {"content" : Global.cats["meow cat"]}


func cmd_report(error : String) -> Dictionary:
	Global.header = ["Content-Type: application/json"]
	if verifyUser():
		var errorFile = File.new()
		errorFile.open("user://error.gg2",File.READ)
		var errNum = int(errorFile.get_line())
		errorFile.close()
		var errTitle : String = "#" + cat(str(errNum),3) + ": "
		errTitle += error.split(",",false,1)[0]
		var errDesc : String = error.split(",",false,1)[1]
		var userName = get_parent().maindict["d"]["author"]["username"]
		var userID = get_parent().maindict["d"]["author"]["id"]
		var userDisc = get_parent().maindict["d"]["author"]["discriminator"]
		var userAvatar = get_parent().maindict["d"]["author"]["avatar"]
		var OSYear = str(OS.get_date(true)["year"])
		var OSMonth = cat(str(OS.get_date(true)["month"]),2)
		var OSDate = cat(str(OS.get_date(true)["day"]),2)
		var OSHr = cat(str(OS.get_time(true)["hour"]),2)
		var OSMin = cat(str(OS.get_time(true)["minute"]),2)
		var OSSec = cat(str(OS.get_time(true)["second"]),2)
		if "," in error:
			errorFile.open("user://error.gg2",File.WRITE)
			errorFile.store_string(str(errNum + 1))
			errorFile.close()
			Global.pin = true
			Global.channel_override = "863837844560805908"
			return {"embeds": [{"title":errTitle,
					"author": {
						"name": "Submitted by: " + userName + "#" + userDisc,
						"icon_url": "https://cdn.discordapp.com/avatars/" + \
						userID + "/" + userAvatar + ".png"
					},
					"color": "0xb40003".hex_to_int(),
					"description":errDesc,
					"timestamp": (OSYear + "-" + OSMonth + \
							"-" + OSDate + "T" + OSHr + ":" + OSMin + ":" + \
							OSSec + ".420Z")
					}]}
		else:
			return {"content" : (Global.cats["sad cat"] + "   Kittea wants you to add a comma between error and description!")}
	else:
		return {"content" : (Global.cats["sad cat"] + "   Kittea ignored your request.")}

func cat(data : String,length : int) -> String:
	var dataReturn = data
	while dataReturn.length() < length:
		dataReturn = "0" + dataReturn
	return dataReturn


func verifyUser() -> bool:
	var messengerID = int(get_parent().maindict["d"]["author"]["id"])
	if messengerID == 197210221406453762:
		return true
	elif messengerID == 213921723190345728:
		return true
	else:
		return false

