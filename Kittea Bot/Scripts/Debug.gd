extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(str(OS.get_date(true)))
	print(str(OS.get_time(true)))
