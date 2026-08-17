extends TextureButton

@export var label : Label;

@export var original_color : Color;
@export var new_color : Color;

func _on_mouse_entered() -> void:
	label.add_theme_color_override("font_color", new_color);

func _on_mouse_exited() -> void:
	label.add_theme_color_override("font_color", original_color);
