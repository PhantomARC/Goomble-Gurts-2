extends Control


var dexNum : Dictionary = {}
var dexName : Dictionary = {}
var dexType : Dictionary = {}
var dexPassive : Dictionary = {}
var dexMoves : Dictionary = {}
var dexStats : Dictionary = {}
var dexlowerName : Dictionary = {}
var infoPassive : Dictionary = {}
var infoMoves : Dictionary = {}
var infolowerMoves : Dictionary = {}


func create_dicts():
	populate_dicts(generate_data("res://resources/goombles.gg2"))
	populate_infoPassive(generate_data("res://resources/passives.gg2"))
	populate_infoMoves(generate_data("res://resources/moves.gg2"))


func generate_data(path) -> Dictionary:
	var file : File = File.new()
	var data : Dictionary = {}
	file.open(path,File.READ)
	var counter : int = 0
	while !file.eof_reached():
		data[counter] = file.get_csv_line()
		counter += 1
	file.close()
	return(data)


func populate_dicts(data : Dictionary):
	for i in data.keys():
		dexNum[i] = data[i]
		dexName[i] = data[i][1]
		dexlowerName[data[i][1].to_lower()] = i
		dexType[i] = data[i][2]
		dexPassive[i] = data[i][3]
		dexMoves[i] = Array(data[i]).slice(4,7)
		dexStats[i] = Array(data[i]).slice(8,14)


func return_data(name : String) -> Dictionary:
	var comp_dict : Dictionary = {}
	if dexlowerName.has(name.to_lower()):
		var id_code = dexlowerName[name.to_lower()]
		comp_dict["id"] = id_code
		comp_dict["name"] = dexName[id_code]
		comp_dict["type"] = dexType[id_code]
		comp_dict["passive"] = dexPassive[id_code]
		comp_dict["moves"] = dexMoves[id_code]
		comp_dict["stats"] = dexStats[id_code]
	return comp_dict


func return_move(name : String) -> Dictionary:
	var comp_dict : Dictionary = {}
	if infolowerMoves.has(name.to_lower()):
		var id_code = infolowerMoves[name.to_lower()]
		comp_dict["name"] = id_code
		comp_dict["cost"] = infoMoves[id_code][0]
		comp_dict["type"] = infoMoves[id_code][1]
		comp_dict["damage"] = infoMoves[id_code][2]
		comp_dict["effect"] = infoMoves[id_code][3]
	return comp_dict


func populate_infoPassive(data : Dictionary):
	for i in data.keys():
		infoPassive[str(data[i][0])] = str(data[i][1])


func populate_infoMoves(data : Dictionary):
	for i in data.keys():
		infoMoves[str(data[i][0])] = Array(data[i]).slice(1,data[i].size(),1,false)
		infolowerMoves[str(data[i][0]).to_lower()] = str(data[i][0])


func get_type(move : String) -> String:
	return infoMoves[move][1]
