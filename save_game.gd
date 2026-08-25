class_name SaveGame
extends Resource

@export var points : int;

@export var cross_hair_texture : ImageTexture;
@export var target_color : Color;

@export var game_last_played : String;
@export var completed_last_game : bool;

@export var high_score_hunting : int;
@export var high_score_timed : int;
@export var high_score_burst : int;
@export var high_score_perfect : int;

@export var number_of_perfects : int;

@export var num_shot : Dictionary;

@export var num_shot_ducks : int;
@export var num_shot_targets : int;

@export var num_shot_ducks_comp : int;
@export var num_shot_targets_comp : int;

@export var completed_quests = ["000", "001", "002", "003", "004", "005", "006", "007", "008"];
@export var completed_quests_values : Array;
