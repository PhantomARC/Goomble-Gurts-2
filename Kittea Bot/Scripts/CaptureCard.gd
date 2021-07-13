extends Control


var success : bool = false


func gen_card(dataName):
	var cardData = load("res://Scenes/Datacard.tscn").instance()
	$View.add_child(cardData)
	success = cardData.materialize(dataName)
	yield(VisualServer, "frame_post_draw")
	var image = $View.get_texture().get_data()
	image.flip_y()
	image.convert(Image.FORMAT_RGBA8)
	image.save_png("user://goomble_card.png")
	return {
		"file1": "C:/Users/TheRoy/Desktop/goomble_card.png",
		"embeds": [{"title": "Kittea showed you a picture.","image": {"url": "https://raw.githubusercontent.com/PhantomARC/Goomble-Gurts-2/main/Sprites/Unused/Cottlecorn.png"}}]} \
		if success else {"content" : "No such goomble exists!"}
