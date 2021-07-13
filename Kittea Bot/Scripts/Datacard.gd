extends Control

onready var paths : Dictionary = {
	"id" : $"Panel/VBind/HBind_ID/CardData/NID/idLabel",
	"name" : $"Panel/VBind/HBind_ID/CardData/NID/nameLabel",
	"passive" : $"Panel/VBind/HBind_ID/CardData/PSV/passiveLabel",
	"entry" : $"Panel/VBind/HBind_ID/CardData/PSV/entryLabel",
	"image" : $"Panel/VBind/HBind_ID/Images/background/goombleImg",
	"type" : $"Panel/VBind/HBind_ID/Images/typeImg",
	"hpBar" : $"Panel/VBind/Stats/statBox_1/hpBar",
	"atkBar" : $"Panel/VBind/Stats/statBox_1/atkBar",
	"dfsBar" : $"Panel/VBind/Stats/statBox_1/dfsBar",
	"magBar" : $"Panel/VBind/Stats/statBox_2/magBar",
	"resBar" : $"Panel/VBind/Stats/statBox_2/resBar",
	"spdBar" : $"Panel/VBind/Stats/statBox_2/spdBar"
}


onready var bank = preload("res://Scripts/goombleBank.gd").new()


func _ready():
	bank.create_dicts()


func materialize(unit) -> bool:
	return produce_card(bank.return_data(unit))


func produce_card(data : Dictionary) -> bool:
	if !data.keys().empty():
		paths["id"].text = "#" + cat(str(data["id"]), 3, '0')
		paths["name"].text = data["name"]
		paths["passive"].text = "<<P>> " + data["passive"] + " "
		paths["image"].texture = load("res://Images/Artwork/" + data["name"] + ".png")
		paths["type"].texture = load("res://Images/template/" + data["type"] + ".png")
		paths["hpBar"].value = int(data["stats"][0])
		paths["hpBar"].get_child(0).text = data["stats"][0]
		paths["atkBar"].value = int(data["stats"][1])
		paths["atkBar"].get_child(0).text = data["stats"][1]
		paths["dfsBar"].value = int(data["stats"][2])
		paths["dfsBar"].get_child(0).text = data["stats"][2]
		paths["magBar"].value = int(data["stats"][3])
		paths["magBar"].get_child(0).text = data["stats"][3]
		paths["resBar"].value = int(data["stats"][4])
		paths["resBar"].get_child(0).text = data["stats"][4]
		paths["spdBar"].value = int(data["stats"][5])
		paths["spdBar"].get_child(0).text = data["stats"][5]
		paths["entry"].text = bank.infoPassive[data["passive"]]
		return true
	else:
		return false


func cat(item:String, length:int, append:String) -> String:
	while item.length() < length:
		item = append + item
	return item
