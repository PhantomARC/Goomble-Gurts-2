extends Node


var prefix = "GG2."
var args : Dictionary = {
	"INFO" : funcref(self,"cmd_info")
	}
var cats : Dictionary = {
	"sad cat" : ('\u002f'+'\u1420'+'\uff61'+'\u2038'+'\uff61'+'\u141f'+'\u005c'),
	"angry cat" : ('\u1c9a'+'\u0028'+'\u003d'+'\u2180'+'\u03c9'+'\u2180'+'\u003d'+'\u0029'+'\u10da'),
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
					return {"content" : (cats["angry cat"] + "   No goomble specified!")}
			else:
				return {"content" : (cats["sad cat"] + "   Kittea could not understand...")}
		else: 
			return {"content" : (cats["angry cat"] + "   Rowr, please wait!")}
	return {}


func cmd_info(name : String) -> Dictionary:
	var tempData = get_tree().get_root().get_node("Core").call("create_img", name)
	if tempData is GDScriptFunctionState:
		tempData = yield(tempData, "completed")
	return tempData
