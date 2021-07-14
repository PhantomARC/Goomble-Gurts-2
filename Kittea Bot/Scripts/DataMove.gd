extends Control


onready var paths : Dictionary = {
	"sticker" : $"Panel/MoveType",
	"bar" : $"Panel/Mana Bar",
	"main" : $"Panel/Data/Main",
	"sub" : $"Panel/Data/Sub",
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
	return produce_card(bank.return_move(unit))


func produce_card(data : Dictionary) -> bool:
	if !data.keys().empty():
		paths["sticker"].texture = load("res://Images/template/Moveblock/" + data["type"] + ".png")
		paths["sticker"].get_child(0).text = data["name"]
		paths["sticker"].get_child(0).add_color_override("font_color", Color(softColor[data["type"]]))
		paths["bar"].value = int(data["cost"])
		paths["bar"].get_child(0).text = data["cost"] +"%"
		paths["main"].text = "Damage:\r\n" + data["damage"]
		paths["sub"].text = "Effect:\r\n" + data["effect"]
		get_parent().get_parent().set_color(colorDict[data["type"]])
		return true
	else:
		get_parent().get_parent().set_color("0x000000")
		return false
