extends Node

@export var timed_high_score : RichTextLabel;
@export var hunting_high_score : RichTextLabel;
@export var burst_high_score : RichTextLabel;
@export var perfect_high_score : RichTextLabel;
@export var last_played : RichTextLabel;

@onready var tree = get_tree();
@onready var menu = "res://nodes/menu.tscn";

@export var least_fav_display : TextureRect;
@export var blank_least_fav : RichTextLabel;

@export var white_duck_texture : Texture2D;
@export var brown_duck_texture : Texture2D;
@export var yellow_duck_texture : Texture2D;

@export var red_target_texture : Texture2D;
@export var colored_target_texture : Texture2D;
@export var white_target_texture : Texture2D;

@export var num_shot_targets : RichTextLabel;
@export var num_shot_ducks : RichTextLabel;
@export var num_shot_completed_targets : RichTextLabel;
@export var num_shot_completed_ducks : RichTextLabel;

@export var perfect_game_teller : RichTextLabel;

func find_most_shot(dict):
	var max_shot = dict.values().max();
	
	if (max_shot == 0):
		return null;
	return dict.keys().get(dict.values().find(max_shot));

func set_values() -> void:
	timed_high_score.text = "High Score (Timed): " + str(PlayerVariables.high_score_timed) + " points";
	hunting_high_score.text = "High Score (Hunting): " + str(PlayerVariables.high_score_hunting) + " points";
	burst_high_score.text = "High Score (Burst): " + str(PlayerVariables.high_score_burst) + " points";
	perfect_high_score.text = "High Score (Perfect): " + str(PlayerVariables.high_score_perfect) + " points";
	
	if (PlayerVariables.game_last_played == ""):
		last_played.text = "No games played yet.";
	else:
		var was_completed := PlayerVariables.completed_last_game;
		
		if (was_completed):
			last_played.text = "Score in last played game (" + PlayerVariables.game_last_played + "): " + str(PlayerVariables.points) + " points";
		else:
			last_played.text = "(INCOMPLETE) Score in last played game (" + PlayerVariables.game_last_played + "): " + str(PlayerVariables.points) + " points";
		
	var most_shot_target = find_most_shot(PlayerVariables.num_shot);
	
	if (most_shot_target != null):
		least_fav_display.visible = true;
		blank_least_fav.visible = false;
		
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
	else:
		least_fav_display.visible = false;
		blank_least_fav.visible = true;
			
	num_shot_ducks.text = "Number of ducks shot (TOTAL): " + str(PlayerVariables.num_shot_ducks);
	num_shot_targets.text = "Number of targets shot (TOTAL): " + str(PlayerVariables.num_shot_targets);
	num_shot_completed_ducks.text = "Number of ducks shot (COMPLETED GAMES): " + str(PlayerVariables.num_shot_ducks_comp);
	num_shot_completed_targets.text = "Number of targets shot (COMPLETED GAMES): " + str(PlayerVariables.num_shot_targets_comp);
	
	perfect_game_teller.text = "[rainbow] Number of Perfects: " + str(PlayerVariables.number_of_perfects);	
	
func _ready() -> void:
	set_values();
	
func _on_return_button_down() -> void:
	tree.change_scene_to_file(menu);
