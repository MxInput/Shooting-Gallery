extends Node

@export var timed_high_score : RichTextLabel;
@export var hunting_high_score : RichTextLabel;
@export var last_played : RichTextLabel;

@onready var tree = get_tree();
@onready var menu = "res://nodes/menu.tscn";

@export var least_fav_display : TextureRect;

@export var white_duck_texture : Texture2D;
@export var brown_duck_texture : Texture2D;
@export var yellow_duck_texture : Texture2D;

@export var red_target_texture : Texture2D;
@export var colored_target_texture : Texture2D;
@export var white_target_texture : Texture2D;

@export var num_shot_targets : RichTextLabel;
@export var num_shot_ducks : RichTextLabel;

func find_most_shot(dict):
	return dict.keys().get(dict.values().find(dict.values().max()));
	
func _ready() -> void:
	timed_high_score.text = "High Score (Timed): " + str(PlayerVariables.high_score_timed) + " points";
	hunting_high_score.text = "High Score (Hunting): " + str(PlayerVariables.high_score_hunting) + " points";
	if (PlayerVariables.game_last_played == ""):
		last_played.text = "No games played yet.";
	else:
		last_played.text = "Score in last played game (" + PlayerVariables.game_last_played + "): " + str(PlayerVariables.points) + " points";
		
	var most_shot_target = find_most_shot(PlayerVariables.num_shot);

	match (most_shot_target):
		"WHITE_TARGET":
			least_fav_display.texture = white_target_texture;
		"COLORED_TARGET":
			least_fav_display.texture = colored_target_texture;
		"RED_TARGET":
			least_fav_display.texture = red_target_texture;
		"YELLOW_DUCK":
			least_fav_display.texture = yellow_duck_texture;
		"BROWN_DUCK":
			least_fav_display.texture = brown_duck_texture;
		"WHITE_DUCK":
			least_fav_display.texture = white_duck_texture;
			
	num_shot_ducks.text = "Number of ducks shot: " + str(PlayerVariables.num_shot_ducks);
	num_shot_targets.text = "Number of targets shot: " + str(PlayerVariables.num_shot_targets);
			
func _on_return_button_down() -> void:
	tree.change_scene_to_file(menu);
