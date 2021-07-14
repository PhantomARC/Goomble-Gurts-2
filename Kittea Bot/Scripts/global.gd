extends Node


var header 
var passthrough
var sleepcounter = -1
var cats : Dictionary = {
	"sad cat" : ('\u002f'+'\u1420'+'\uff61'+'\u2038'+'\uff61'+'\u141f'+'\u005c'),
	"angry cat" : ('\u1c9a'+'\u0028'+'\u003d'+'\u2180'+'\u03c9'+'\u2180'+'\u003d'+'\u0029'+'\u10da'),
	"purr cat" : ('\u0028'+'\u003d'+'\u005e'+'\u002d'+'\u03c9'+'\u002d'+'\u005e'+'\u003d'+'\u0029'),
	"content cat" : ('\u0028'+'\u003d'+'\u00b4'+'\u2207'+'\uff40'+'\u003d'+'\u0029'),
	"meow cat" : ('\u002f'+'\u1420'+'\u002e'+'\u0020'+'\uff61'+'\u002e'+'\u141f'+'\u005c'+'\u005c'+'\u1d50'+'\u1d49'+'\u1d52'+'\u02b7'+'\u02ce'+'\u02ca'+'\u02d7'),
}

func _process(delta):
	if !(sleepcounter == -1):
		sleepcounter -= 1
		if sleepcounter == 0:
			get_tree().quit()

var pixelCat : String = ":white_large_square::white_large_square::white_large_square::white_large_square::white_large_square::white_large_square::white_large_square::white_large_square::white_large_square::white_large_square:\r\n"+\
":white_large_square::white_large_square::white_large_square::black_large_square::white_large_square::white_large_square::white_large_square::black_large_square::white_large_square::white_large_square:\r\n"+\
":white_large_square::white_large_square::white_large_square::black_large_square::black_large_square::black_large_square::black_large_square::black_large_square::black_large_square::white_large_square:\r\n"+\
":white_large_square::white_large_square::white_large_square::black_large_square::black_large_square::white_large_square::black_large_square::white_large_square::black_large_square::white_large_square:\r\n"+\
":white_large_square::white_large_square::white_large_square::black_large_square::black_large_square::black_large_square::black_large_square::black_large_square::black_large_square::white_large_square:\r\n"+\
":white_large_square::black_large_square::black_large_square::black_large_square::white_large_square::white_large_square::white_large_square::white_large_square::black_large_square::white_large_square:\r\n"+\
":white_large_square::black_large_square::white_large_square::black_large_square::black_large_square::white_large_square::white_large_square::black_large_square::black_large_square::white_large_square:\r\n"+\
":white_large_square::black_large_square::black_large_square::black_large_square::brown_square::brown_square::brown_square::brown_square::black_large_square::white_large_square:\r\n"+\
":red_square::red_square::red_square::black_large_square::black_large_square::black_large_square::black_large_square::black_large_square::black_large_square::red_square:\r\n"+\
":red_square::red_square::red_square::red_square::red_square::red_square::red_square::red_square::red_square::red_square:"
