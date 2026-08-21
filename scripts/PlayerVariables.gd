extends Node

var points := 0;

var cross_hair_texture := load("res://images/crosshairs/crosshair_outline_small.png");
var target_color := Color.WHITE;

var game_last_played := "";
var completed_last_game := false;

var high_score_hunting := 0;
var high_score_timed := 0;
var high_score_burst := 0;
var high_score_perfect := 0;

var number_of_perfects := 0;

var num_shot = {
	"WHITE_TARGET": 0,
	"COLORED_TARGET": 0,
	"RED_TARGET": 0,
	"YELLOW_DUCK": 0,
	"BROWN_DUCK": 0,
	"WHITE_DUCK": 0
}

var num_shot_ducks := 0;
var num_shot_targets := 0;

var num_shot_ducks_comp := 0;
var num_shot_targets_comp := 0;

var complete_status_quests : Array;

const SAVE_PATH := "user://shooting_save.tres"

var save_game : SaveGame = null;

func _ready() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		save_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE);
	
		points = save_game.points;
		
		cross_hair_texture = save_game.cross_hair_texture;
		target_color = save_game.target_color;
		
		game_last_played = save_game.game_last_played;
		completed_last_game = save_game.completed_last_game;
		
		high_score_burst = save_game.high_score_burst;
		high_score_hunting = save_game.high_score_hunting;
		high_score_perfect = save_game.high_score_perfect;
		high_score_timed = save_game.high_score_timed;
		
		number_of_perfects = save_game.number_of_perfects;
		
		num_shot = save_game.num_shot;
		
		num_shot_ducks = save_game.num_shot_ducks;
		num_shot_targets = save_game.num_shot_targets;
		
		num_shot_ducks_comp = save_game.num_shot_ducks_comp;
		num_shot_targets_comp = save_game.num_shot_targets_comp;
		
		complete_status_quests = save_game.completed_quests_values;
	else:
		save_game = SaveGame.new();
		
		var temp_shop_inventory = ShopInventory.new();
		var shop_items = temp_shop_inventory.inventory;

		var count = 0;
		for item in shop_items:
			if (count == 0):
				complete_status_quests.push_back(true);	
			else:
				complete_status_quests.push_back(false);
			count += 1;
			
func write_to_save() -> void:
	var error := ResourceSaver.save(save_game, SAVE_PATH);
	if (error != OK):
		push_error("Failed to Save, err: " + error_string(error));
