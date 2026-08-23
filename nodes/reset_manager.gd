extends Control

@export var info : Node;

func _on_reset_button_down() -> void:
	PlayerVariables.points = 0;

	PlayerVariables.cross_hair_texture = load("res://images/crosshairs/crosshair_outline_small.png");
	PlayerVariables.target_color = Color.WHITE;

	PlayerVariables.game_last_played = "";
	PlayerVariables.completed_last_game = false;

	PlayerVariables.high_score_hunting = 0;
	PlayerVariables.high_score_timed = 0;
	PlayerVariables.high_score_burst = 0;
	PlayerVariables.high_score_perfect = 0;

	PlayerVariables.number_of_perfects = 0;

	PlayerVariables.num_shot = {
		"WHITE_TARGET": 0,
		"COLORED_TARGET": 0,
		"RED_TARGET": 0,
		"YELLOW_DUCK": 0,
		"BROWN_DUCK": 0,
		"WHITE_DUCK": 0
	}

	PlayerVariables.num_shot_ducks = 0;
	PlayerVariables.num_shot_targets = 0;

	PlayerVariables.num_shot_ducks_comp = 0;
	PlayerVariables.num_shot_targets_comp = 0;

	PlayerVariables.complete_status_quests.clear();
	
	var temp_shop_inventory = ShopInventory.new();
	var shop_items = temp_shop_inventory.inventory;

	var count = 0;
	for item in shop_items:
		if (count == 0):
			PlayerVariables.complete_status_quests.push_back(true);	
		else:
			PlayerVariables.complete_status_quests.push_back(false);
		count += 1;
			
	PlayerVariables.save_game.points = PlayerVariables.points;
		
	var initial_crosshair_img := load("res://images/crosshair_img/crosshair_outline_small.png");
	PlayerVariables.save_game.cross_hair_texture = ImageTexture.new().create_from_image(initial_crosshair_img);
	PlayerVariables.save_game.target_color = PlayerVariables.target_color;
		
	PlayerVariables.save_game.game_last_played = PlayerVariables.game_last_played;
	PlayerVariables.save_game.completed_last_game = PlayerVariables.completed_last_game;
		
	PlayerVariables.save_game.high_score_burst = PlayerVariables.high_score_burst;
	PlayerVariables.save_game.high_score_hunting = PlayerVariables.high_score_hunting;
	PlayerVariables.save_game.high_score_perfect = PlayerVariables.high_score_perfect;
	PlayerVariables.save_game.high_score_timed = PlayerVariables.high_score_timed;
		
	PlayerVariables.save_game.number_of_perfects = PlayerVariables.number_of_perfects;
		
	PlayerVariables.save_game.num_shot = PlayerVariables.num_shot;
		
	PlayerVariables.save_game.num_shot_ducks = PlayerVariables.num_shot_ducks;
	PlayerVariables.save_game.num_shot_ducks_comp = PlayerVariables.num_shot_ducks_comp;
		
	PlayerVariables.save_game.num_shot_targets = PlayerVariables.num_shot_targets;
	PlayerVariables.save_game.num_shot_targets_comp = PlayerVariables.num_shot_targets_comp;
		
	PlayerVariables.save_game.completed_quests_values = PlayerVariables.complete_status_quests;
		
	PlayerVariables.write_to_save();
	
	info.set_values();
