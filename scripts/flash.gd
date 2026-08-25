extends RichTextLabel

@export var color1 : Color;
@export var color2 : Color;

var turning := true;
var time := 0.0;

func _process(delta: float) -> void:
	var font_color = get_theme_color("default_color");

	if (font_color == color1 && turning):
		turning = false;
		time = 0.0;
		
	elif (font_color == color2 && !turning):
		turning = true;
		time = 0.0;

	if (turning):
		add_theme_color_override("default_color", lerp(font_color, color1, time)); 
	else:
		add_theme_color_override("default_color", lerp(font_color, color2, time)); 
		
	time += delta/3.0;
