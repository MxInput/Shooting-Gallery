extends Node

@export var color_picker : ColorPicker;

@onready var menu = "res://nodes/menu.tscn";
@onready var tree = get_tree();

func _ready() -> void:
	color_picker.color = PlayerVariables.target_color;

func _on_color_picker_color_changed(color: Color) -> void:
	PlayerVariables.target_color = color;

func _on_return_button_down() -> void:
	tree.change_scene_to_file(menu);
