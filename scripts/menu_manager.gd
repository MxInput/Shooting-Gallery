extends Node

@export var timed_game : PackedScene;
@export var hunting_game : PackedScene;

func _on_timed_button_down() -> void:
	get_tree().change_scene_to_packed(timed_game);
	
func _on_hunting_button_down() -> void:
	get_tree().change_scene_to_packed(hunting_game);
