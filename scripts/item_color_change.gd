extends TextureButton

@export var label : Label;

@export var original_color : Color;
@export var new_color : Color;

@export var container : TextureRect;

@export var red_button_normal : CompressedTexture2D;
@export var red_button_hover : CompressedTexture2D;

@export var red_color : Color;

var original_pos : Vector2;
var time := 0.0;
var moving := false;
var moving_right := true;
var distance := 2.0;

func _on_mouse_entered() -> void:
	label.add_theme_color_override("font_color", new_color);

func _on_mouse_exited() -> void:
	if (container.unlocked):
		label.add_theme_color_override("font_color", original_color);
	else:
		label.add_theme_color_override("font_color", red_color);

func start_moving() -> void:
	moving = true;
	moving_right = true;
	original_pos = position;

func jiggle() -> void:
	if (moving_right):
		position.x += 0.4;
		
		var end_pos = original_pos.x + distance;
		
		if (position.x >= end_pos):
			moving_right = false;
	else:
		position.x -= 0.4;
		
		var end_pos = original_pos.x - distance;
		
		if (position.x <= end_pos):
			moving_right = true;
		
func is_moving() -> bool:
	return moving;
	
func _process(delta: float) -> void:
	if (moving):
		time += delta;
		
		jiggle();
	
		if (time > 1.0):
			moving = false;
			moving_right = true;
			
			position = original_pos;
			
			time = 0.0;
			
func _on_crosshair_container_renamed() -> void:
	if (!container.unlocked):
		texture_normal = red_button_normal;
		texture_hover = red_button_hover;
		texture_pressed = red_button_hover;
		
		label.add_theme_color_override("font_color", red_color);
		label.text = "LOCKED";
