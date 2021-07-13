extends Control


func create_img(dataName : String) -> Dictionary:
	var capture_card = load("res://Scenes/CaptureCard.tscn").instance()
	add_child(capture_card)
	var data = capture_card.gen_card(dataName)
	if data is GDScriptFunctionState:
		data = yield(data,"completed")
	capture_card.queue_free()
	return data
