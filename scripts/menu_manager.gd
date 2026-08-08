extends Node

@export var timed_game : PackedScene;
@export var hunting_game : PackedScene;
@export var customize_page : PackedScene;
@export var info_page : PackedScene;

func _on_timed_button_down() -> void:
	PlayerVariables.points = 0;
	get_tree().change_scene_to_packed(timed_game);
	
func _on_hunting_button_down() -> void:
	PlayerVariables.points = 0;
	get_tree().change_scene_to_packed(hunting_game);

func _on_customize_button_down() -> void:
	PlayerVariables.points = 0;
	get_tree().change_scene_to_packed(customize_page);

func _on_info_button_down() -> void:
	PlayerVariables.points = 0;
	get_tree().change_scene_to_packed(info_page);
