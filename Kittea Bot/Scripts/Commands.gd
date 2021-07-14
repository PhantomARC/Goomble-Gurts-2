extends Node


var prefix = "GG2."
var args : Dictionary = {
	"INFO" : funcref(self,"cmd_info"),
	"SLEEP" : funcref(self,"cmd_sleep"),
	"MOVE" : funcref(self,"cmd_move"),
	"KITTEA" : funcref(self,"cmd_kittea")
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
	if (int(get_parent().maindict["d"]["author"]["id"]) == 197210221406453762) and \
		int(get_parent().maindict["d"]["author"]["discriminator"]) == 0404:
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
