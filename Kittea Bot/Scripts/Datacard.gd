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
	"spdBar" : $"Panel/VBind/Stats/statBox_2/spdBar",
	"move1" : $"Panel/VBind/moveBox/m1",
	"move2" : $"Panel/VBind/moveBox/m2",
	"move3" : $"Panel/VBind/moveBox/m3",
	"move4" : $"Panel/VBind/moveBox/m4",
}
onready var bank = preload("res://Scripts/goombleBank.gd").new()

var colorDict : Dictionary = {
	"Pepper" : "0xb40003",
	"Oil" : "0x4c4a44",
	"Chalk" : "0xfff4dd",
	"Neutral" : "0xb9b4a5",
	"Glitch" : "0x00ffff",
}

var softColor : Dictionary = {
	"Pepper" : "#760002",
	"Oil" : "#000000",
	"Chalk" : "#b9b4a5",
	"Neutral" : "#4c4a44",
	"Glitch" : "#b40003",
}

func _ready():
	add_child(bank)
	bank.create_dicts()


func materialize(unit) -> bool:
	return produce_card(bank.return_data(unit))


func produce_card(data : Dictionary) -> bool:
	if !data.keys().empty():
		paths["id"].text = "#" + cat(str(data["id"]), 3, '0')
		paths["name"].text = data["name"]
		paths["passive"].text = "<<P>> " + data["passive"] + " "
		paths["image"].texture = load("res://Images/Artwork/" + data["name"] + ".png")
		paths["type"].texture = load("res://Images/template/Typeblock/" + data["type"] + ".png")
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
		paths["move1"].texture = load("res://Images/template/Moveblock/" + bank.get_type(data["moves"][0]) + ".png")
		paths["move1"].get_child(0).text = data["moves"][0]
		paths["move1"].get_child(0).add_color_override("font_color", Color(softColor[bank.get_type(data["moves"][0])]))
		paths["move2"].texture = load("res://Images/template/Moveblock/" + bank.get_type(data["moves"][1]) + ".png")
		paths["move2"].get_child(0).text = data["moves"][1]
		paths["move2"].get_child(0).add_color_override("font_color", Color(softColor[bank.get_type(data["moves"][1])]))
		paths["move3"].texture = load("res://Images/template/Moveblock/" + bank.get_type(data["moves"][2]) + ".png")
		paths["move3"].get_child(0).text = data["moves"][2]
		paths["move3"].get_child(0).add_color_override("font_color", Color(softColor[bank.get_type(data["moves"][2])]))
		paths["move4"].texture = load("res://Images/template/Moveblock/" + bank.get_type(data["moves"][3]) + ".png")
		paths["move4"].get_child(0).text = data["moves"][3]
		paths["move4"].get_child(0).add_color_override("font_color", Color(softColor[bank.get_type(data["moves"][3])]))
		get_parent().get_parent().set_color(colorDict[data["type"]])
		return true
	else:
		get_parent().get_parent().set_color("0x000000")
		return false


func cat(item:String, length:int, append:String) -> String:
	while item.length() < length:
		item = append + item
	return item
