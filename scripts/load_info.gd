extends Node

@export var timed_high_score : RichTextLabel;
@export var hunting_high_score : RichTextLabel;
@export var last_played : RichTextLabel;

@onready var tree = get_tree();
@onready var menu = "res://nodes/menu.tscn";

func _ready() -> void:
	timed_high_score.text = "High Score (Timed): " + str(PlayerVariables.high_score_timed) + " points";
	hunting_high_score.text = "High Score (Hunting): " + str(PlayerVariables.high_score_hunting) + " points";
	if (PlayerVariables.game_last_played == ""):
		last_played.text = "No games played yet.";
	else:
		last_played.text = "Score in last played game (" + PlayerVariables.game_last_played + "): " + str(PlayerVariables.points) + " points";

func _on_return_button_down() -> void:
	tree.change_scene_to_file(menu);
