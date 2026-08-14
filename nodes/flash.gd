extends RichTextLabel

@export var color1 : Color;
@export var color2 : Color;

var turning := true;
var time := 0;

func _process(delta: float) -> void:
	var font_color = get_theme_color("default_color");
	
	if ()

	if (turning):
		set_theme_color("default_color", lerp(font_color, color1)) 
	else:
		
		
	
