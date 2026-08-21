extends TextureButton

@export var label : Label;

@export var original_color : Color;
@export var new_color : Color;

@export var container : TextureRect;

@export var red_button_normal : CompressedTexture2D;
@export var red_button_hover : CompressedTexture2D;

@export var red_color : Color;

func _ready() -> void:
	if (!container.unlocked):
		texture_normal = red_button_normal;
		texture_hover = red_button_hover;
		texture_pressed = red_button_hover;
		
		label.add_theme_color_override("font_color", red_color);
		
func _on_mouse_entered() -> void:
	if (container.unlocked):
		label.add_theme_color_override("font_color", new_color);
	else:
		label.add_theme_color_override("font_color", red_color);

func _on_mouse_exited() -> void:
	label.add_theme_color_override("font_color", original_color);
