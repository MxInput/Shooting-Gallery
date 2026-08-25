extends Node2D

var points := 0;
signal hit(obj, point_value, order);

var moving_up = true;
var original_y;

var distance := 10.0;

var upper_speed := 6.0;
var lower_speed := 4.0;

var end_pos := -700.0;

var speed = randf_range(lower_speed, upper_speed);

var shot := false;

var time_till_destory := 2.0;
var time_left := 0.0;

@onready var points_teller := find_child("Points");

var canvas_layer : CanvasLayer;

@export var points_icon : PackedScene;
@export var shot_particles : PackedScene;

signal updateLives;

var pause_manager : Node;

var game;

func _ready() -> void:
	var aim_controller = get_parent().find_child("AimController");
	var target_spawner = get_parent().find_child("TargetSpawner");
	pause_manager = get_parent().find_child("PauseManager");
	hit.connect(aim_controller.destroy_target);
	
	game = get_parent();
	canvas_layer = game.find_child("CanvasLayer");
	
	if (target_spawner.find_child("GameTimer") == null):
		if (game.game_mode == GameDetails.GameModes.HUNTING):
			updateLives.connect(target_spawner.updateLives);
		
	if (game.game_mode == GameDetails.GameModes.BURST || game.game_mode == GameDetails.GameModes.EXACT):
		if (target_spawner.waves_remaining <= target_spawner.max_waves):
			upper_speed = target_spawner.upper_speeds[target_spawner.waves_remaining];
			lower_speed = target_spawner.lower_speeds[target_spawner.waves_remaining];

			speed = randf_range(lower_speed, upper_speed);		
			
func change_speed(us, ls) -> void:
	lower_speed = ls;
	upper_speed = us;
	
func _process(delta: float) -> void:	
	if (!pause_manager.is_paused()):
		if (!shot):
			if (original_y != null):
				if (moving_up):
					position.y += 0.5;
					
					if (position.y >= original_y + distance):
						moving_up = false;
				else:
					position.y -= 0.5;
					
					if (position.y <= original_y - distance):
						moving_up = true;
					
			position.x -= speed;
			
			if (position.x <= end_pos):
				var duck_sprite = find_child("Duck", true, false);
				var target_sprite = find_child("Target", true, false);
				
				var target_spawner = get_parent().find_child("TargetSpawner");
				if (target_spawner.find_child("GameTimer") != null || game.game_mode == GameDetails.GameModes.BURST || game.game_mode == GameDetails.GameModes.EXACT):
					if (game.game_mode == GameDetails.GameModes.BURST || game.game_mode == GameDetails.GameModes.EXACT || !target_spawner.game_timer.is_stopped()):
						var perfect_text := canvas_layer.find_child("PerfectTeller");
						perfect_text.visible = false;
						
						if (game.game_mode == GameDetails.GameModes.BURST || game.game_mode == GameDetails.GameModes.EXACT):
							if (duck_sprite != null):
								match (duck_sprite.texture):
									target_spawner.white_duck_texture:
										target_spawner.spawned_targets["WHITE_DUCK"].erase(self);
									target_spawner.brown_duck_texture:
										target_spawner.spawned_targets["BROWN_DUCK"].erase(self);
									target_spawner.yellow_duck_texture:					
										target_spawner.spawned_targets["YELLOW_DUCK"].erase(self);
							elif (target_sprite != null):
								match (target_sprite.texture):
									target_spawner.colored_target_texture:
										target_spawner.spawned_targets["COLORED_TARGET"].erase(self);
									target_spawner.red_target_texture:
										target_spawner.spawned_targets["RED_TARGET"].erase(self);			
									target_spawner.white_target_texture:					
										target_spawner.spawned_targets["WHITE_TARGET"].erase(self);
						
						if (game.game_mode == GameDetails.GameModes.EXACT):
							var new_points_total_icon = points_icon.instantiate();
							canvas_layer.add_child(new_points_total_icon);
							new_points_total_icon.text = "-" + str(points);
							new_points_total_icon.modulate = Color.CRIMSON;
							new_points_total_icon.position = Vector2(160.0, 100.0);
							
							hit.emit(self, -points, z_index);	
				else:
					var current_target = target_spawner.chosen_hit;
					var target_type = target_spawner.chosen_type;
					if (target_type == "Duck"):
						if (duck_sprite != null):
							match (current_target):
								"WHITE":
									if (duck_sprite.texture == target_spawner.white_duck_texture):
										target_spawner.lives -= 1;
										target_spawner.number_on_screen -= 1;
										
										updateLives.emit();
								"BROWN":
									if (duck_sprite.texture == target_spawner.brown_duck_texture):
										target_spawner.lives -= 1;
										target_spawner.number_on_screen -= 1;
										
										updateLives.emit();
								"YELLOW":
									if (duck_sprite.texture == target_spawner.yellow_duck_texture):
										target_spawner.lives -= 1;
										target_spawner.number_on_screen -= 1;
										
										updateLives.emit();
					elif (target_type == "Target"):
						if (target_sprite != null):
							match (current_target):
								"WHITE":
									if (target_sprite.texture == target_spawner.white_target_texture):
										target_spawner.lives -= 1;
										target_spawner.number_on_screen -= 1;
										
										updateLives.emit();
								"COLORED":
									if (target_sprite.texture == target_spawner.colored_target_texture):
										target_spawner.lives -= 1;
										target_spawner.number_on_screen -= 1;

										updateLives.emit();
								"RED":
									if (target_sprite.texture == target_spawner.red_target_texture):
										target_spawner.lives -= 1;
										target_spawner.number_on_screen -= 1;
									
										updateLives.emit();
				
					if (duck_sprite != null):
						match (duck_sprite.texture):
							target_spawner.white_duck_texture:
								target_spawner.spawned_targets["WHITE_DUCK"].erase(self);
							target_spawner.brown_duck_texture:
								target_spawner.spawned_targets["BROWN_DUCK"].erase(self);
							target_spawner.yellow_duck_texture:					
								target_spawner.spawned_targets["YELLOW_DUCK"].erase(self);
					elif (target_sprite != null):
						match (target_sprite.texture):
							target_spawner.colored_target_texture:
								target_spawner.spawned_targets["COLORED_TARGET"].erase(self);
							target_spawner.red_target_texture:
								target_spawner.spawned_targets["RED_TARGET"].erase(self);			
							target_spawner.white_target_texture:					
								target_spawner.spawned_targets["WHITE_TARGET"].erase(self);
						
				queue_free();
		else:
			time_left += delta;
			
			if (time_left >= time_till_destory):
				queue_free();
		
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var aim_controller = get_parent().find_child("AimController");
	var target_spawner = get_parent().find_child("TargetSpawner");
	if (!pause_manager.is_paused()):	
		if (target_spawner.find_child("GameTimer") != null):
			if (!target_spawner.game_timer.is_stopped()):
				if (event.is_action("left_click")):
					if (!shot && (!aim_controller.blocked || (z_index != 2))):
						if (aim_controller.loaded):	
							var new_points_icon = points_icon.instantiate();
							canvas_layer.add_child(new_points_icon);
							
							var new_points_total_icon = points_icon.instantiate();
							canvas_layer.add_child(new_points_total_icon);
							new_points_total_icon.text = "+" + str(points);
							new_points_total_icon.modulate = Color.DARK_GREEN;
							new_points_total_icon.position = Vector2(160.0, 100.0);
							
							var new_shot_particles := shot_particles.instantiate();
							add_child(new_shot_particles);
							new_shot_particles.emitting = true;
							new_shot_particles.global_position = get_global_mouse_position();
							
							if (is_in_group("duck")):
								var duck_sprite = find_child("Duck", true, false);
								match (duck_sprite.texture):
									target_spawner.brown_duck_texture:
										PlayerVariables.num_shot["BROWN_DUCK"] += 1;
										PlayerVariables.save_game.num_shot["BROWN_DUCK"] += 1;
										
										new_shot_particles.color = Color.from_string("#a36a31", Color.SADDLE_BROWN);
									target_spawner.yellow_duck_texture:
										PlayerVariables.num_shot["YELLOW_DUCK"] += 1;
										PlayerVariables.save_game.num_shot["YELLOW_DUCK"] += 1;
										
										new_shot_particles.color = Color.from_string("#edae1a", Color.YELLOW);
									target_spawner.white_duck_texture:
										PlayerVariables.num_shot["WHITE_DUCK"] += 1;
										PlayerVariables.save_game.num_shot["WHITE_DUCK"] += 1;
										
										new_shot_particles.color = Color.from_string("#dbd895", Color.WHITE);
										
								if (!PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("001")]):
									PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("001")] = true;
									PlayerVariables.save_game.completed_quests_values = PlayerVariables.complete_status_quests;

									PlayerVariables.write_to_save();
									
								PlayerVariables.num_shot_ducks += 1;
								PlayerVariables.save_game.num_shot_ducks += 1;
								aim_controller.duck_count += 1;
								new_points_icon.position = Vector2(434.0, 100.0);
							else:
								var target_sprite = find_child("Target", true, false);		
								
								match (target_sprite.texture):
									target_spawner.colored_target_texture:
										PlayerVariables.num_shot["COLORED_TARGET"] += 1;
										PlayerVariables.save_game.num_shot["COLORED_TARGET"] += 1;
										
										new_shot_particles.color = Color.from_string("#207bb0", Color.WHITE);
									target_spawner.red_target_texture:
										PlayerVariables.num_shot["RED_TARGET"] += 1;
										PlayerVariables.save_game.num_shot["RED_TARGET"] += 1;
										
										new_shot_particles.color = Color.from_string("#cf560a", Color.DARK_RED);
									target_spawner.white_target_texture:
										PlayerVariables.num_shot["WHITE_TARGET"] += 1;
										PlayerVariables.save_game.num_shot["WHITE_TARGET"] += 1;
										
										new_shot_particles.color = Color.WHITE;
										
								if (!PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("002")]):
									PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("002")] = true;
									PlayerVariables.save_game.completed_quests_values = PlayerVariables.complete_status_quests;
									
									PlayerVariables.write_to_save();
									
								PlayerVariables.num_shot_targets += 1;
								PlayerVariables.save_game.num_shot_targets += 1;
								aim_controller.target_count += 1;
								new_points_icon.position = Vector2(670.0, 100.0);
								
							shot = true;
							points_teller.text = "+" + str(points);
							points_teller.reparent(canvas_layer);
							points_teller.global_position = get_viewport().get_mouse_position();
							points_teller.visible = true;
							match points:
								2:
									points_teller.modulate = Color.DEEP_SKY_BLUE;
								3:
									points_teller.modulate = Color.HOT_PINK;
								4:
									points_teller.modulate = Color.ORANGE;
								5:
									points_teller.modulate = Color.SEA_GREEN;
								7:
									points_teller.modulate = Color.YELLOW;
						hit.emit(self, points, z_index);
		elif ((game.game_mode == GameDetails.GameModes.BURST && target_spawner.waves_remaining <= target_spawner.max_waves) || (game.game_mode == GameDetails.GameModes.EXACT && target_spawner.waves_remaining <= target_spawner.max_waves)):
			if (event.is_action("left_click")):
					if (!shot && (!aim_controller.blocked || (z_index != 2))):
						if (aim_controller.loaded):	
							var new_points_icon = points_icon.instantiate();
							canvas_layer.add_child(new_points_icon);
							
							var new_points_total_icon = points_icon.instantiate();
							canvas_layer.add_child(new_points_total_icon);
							new_points_total_icon.text = "+" + str(points);
							new_points_total_icon.modulate = Color.DARK_GREEN;
							new_points_total_icon.position = Vector2(160.0, 100.0);
							
							var new_shot_particles := shot_particles.instantiate();
							add_child(new_shot_particles);
							new_shot_particles.emitting = true;
							new_shot_particles.global_position = get_global_mouse_position();
							
							if (is_in_group("duck")):
								var duck_sprite = find_child("Duck", true, false);
								match (duck_sprite.texture):
									target_spawner.brown_duck_texture:
										PlayerVariables.num_shot["BROWN_DUCK"] += 1;
										PlayerVariables.save_game.num_shot["BROWN_DUCK"] += 1;
										
										new_shot_particles.color = Color.from_string("#a36a31", Color.SADDLE_BROWN);
										target_spawner.spawned_targets["BROWN_DUCK"].erase(self);
									target_spawner.yellow_duck_texture:
										PlayerVariables.num_shot["YELLOW_DUCK"] += 1;
										PlayerVariables.save_game.num_shot["YELLOW_DUCK"] += 1;
										
										new_shot_particles.color = Color.from_string("#edae1a", Color.YELLOW);
										target_spawner.spawned_targets["YELLOW_DUCK"].erase(self);
									target_spawner.white_duck_texture:
										PlayerVariables.num_shot["WHITE_DUCK"] += 1;
										PlayerVariables.save_game.num_shot["WHITE_DUCK"] += 1;
										
										target_spawner.spawned_targets["WHITE_DUCK"].erase(self);
										new_shot_particles.color = Color.from_string("#dbd895", Color.WHITE);
										
								if (!PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("001")]):
									PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("001")] = true;
									PlayerVariables.save_game.completed_quests_values = PlayerVariables.complete_status_quests;
									
									PlayerVariables.write_to_save();
								
								PlayerVariables.num_shot_ducks += 1;
								PlayerVariables.save_game.num_shot_ducks += 1;
								aim_controller.duck_count += 1;
								new_points_icon.position = Vector2(434.0, 100.0);
							else:
								var target_sprite = find_child("Target", true, false);		
								
								match (target_sprite.texture):
									target_spawner.colored_target_texture:
										PlayerVariables.num_shot["COLORED_TARGET"] += 1;
										PlayerVariables.save_game.num_shot["COLORED_TARGET"] += 1;
										
										target_spawner.spawned_targets["COLORED_TARGET"].erase(self);	
										new_shot_particles.color = Color.from_string("#207bb0", Color.WHITE);
									target_spawner.red_target_texture:
										PlayerVariables.num_shot["RED_TARGET"] += 1;
										PlayerVariables.save_game.num_shot["RED_TARGET"] += 1;
										
										new_shot_particles.color = Color.from_string("#cf560a", Color.DARK_RED);
										target_spawner.spawned_targets["RED_TARGET"].erase(self);
									target_spawner.white_target_texture:
										PlayerVariables.num_shot["WHITE_TARGET"] += 1;
										PlayerVariables.save_game.num_shot["WHITE_TARGET"] += 1;
										
										target_spawner.spawned_targets["WHITE_TARGET"].erase(self);	
										new_shot_particles.color = Color.WHITE;
								
								if (!PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("002")]):
									PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("002")] = true;
									PlayerVariables.save_game.completed_quests_values = PlayerVariables.complete_status_quests;
									
									PlayerVariables.write_to_save();
									
								PlayerVariables.num_shot_targets += 1;
								PlayerVariables.save_game.num_shot_targets += 1;
								aim_controller.target_count += 1;
								new_points_icon.position = Vector2(670.0, 100.0);
								
							shot = true;
							points_teller.text = "+" + str(points);
							points_teller.reparent(canvas_layer);
							points_teller.global_position = get_viewport().get_mouse_position();
							points_teller.visible = true;
							match points:
								2:
									points_teller.modulate = Color.DEEP_SKY_BLUE;
								3:
									points_teller.modulate = Color.HOT_PINK;
								4:
									points_teller.modulate = Color.ORANGE;
								5:
									points_teller.modulate = Color.SEA_GREEN;
								7:
									points_teller.modulate = Color.YELLOW;
						hit.emit(self, points, z_index);
		elif (game.game_mode == GameDetails.GameModes.HUNTING && target_spawner.lives > 0):
				if (event.is_action("left_click")):
					var wrong_target = false;
					
					if (!shot && (!aim_controller.blocked || (z_index != 2))):
						if (aim_controller.loaded):	
							var current_target = target_spawner.chosen_hit;
							var target_type = target_spawner.chosen_type;
							if (target_type == "Target"):
								var target_sprite = find_child("Target");		
								
								if (target_sprite == null):
									wrong_target = true;
									target_spawner.lives -= 1;
									updateLives.emit();
								else:
									match (current_target):
										"WHITE":
											if (target_sprite.texture != target_spawner.white_target_texture):
												target_spawner.lives -= 1;
												wrong_target = true;
												updateLives.emit();
											target_spawner.spawned_targets["WHITE_TARGET"].erase(self);	
										"COLORED":
											if (target_sprite.texture != target_spawner.colored_target_texture):
												target_spawner.lives -= 1;
												wrong_target = true;
												updateLives.emit();
											target_spawner.spawned_targets["COLORED_TARGET"].erase(self);	
										"RED":
											if (target_sprite.texture != target_spawner.red_target_texture):
												target_spawner.lives -= 1;
												wrong_target = true;
												updateLives.emit();
											target_spawner.spawned_targets["RED_TARGET"].erase(self);
							elif (target_type == "Duck"):
								var duck_sprite = find_child("Duck");
								
								if (duck_sprite == null):
									target_spawner.lives -= 1;
									wrong_target = true;
									updateLives.emit();
								else:
									match (current_target):
										"WHITE":
											if (duck_sprite.texture != target_spawner.white_duck_texture):
												target_spawner.lives -= 1;
												wrong_target = true;
												updateLives.emit();
											target_spawner.spawned_targets["WHITE_DUCK"].erase(self);
										"BROWN":
											if (duck_sprite.texture != target_spawner.brown_duck_texture):
												target_spawner.lives -= 1;
												wrong_target = true;
												updateLives.emit();
											target_spawner.spawned_targets["BROWN_DUCK"].erase(self);
										"YELLOW":
											if (duck_sprite.texture != target_spawner.yellow_duck_texture):
												target_spawner.lives -= 1;		
												wrong_target = true;
												updateLives.emit();	
											target_spawner.spawned_targets["YELLOW_DUCK"].erase(self);
											
							var new_points_total_icon = points_icon.instantiate();
							canvas_layer.add_child(new_points_total_icon);
							new_points_total_icon.position = Vector2(160.0, 100.0);
							
							var new_points_icon = points_icon.instantiate();
							
							if (!wrong_target):
								canvas_layer.add_child(new_points_icon);
								
								new_points_total_icon.text = "+" + str(points);
								new_points_total_icon.modulate = Color.DARK_GREEN;
							else:
								new_points_total_icon.text = "-" + str(points);
								new_points_total_icon.modulate = Color.CRIMSON;
							
							var new_shot_particles := shot_particles.instantiate();
							add_child(new_shot_particles);
							new_shot_particles.emitting = true;
							new_shot_particles.global_position = get_global_mouse_position();
							
							if (is_in_group("duck")):
								var duck_sprite = find_child("Duck");
								match (duck_sprite.texture):
									target_spawner.brown_duck_texture:
										new_shot_particles.color = Color.from_string("#a36a31", Color.SADDLE_BROWN);
										if (!wrong_target):
											PlayerVariables.num_shot["BROWN_DUCK"] += 1;
											PlayerVariables.save_game.num_shot["BROWN_DUCK"] += 1;
									target_spawner.yellow_duck_texture:
										new_shot_particles.color = Color.from_string("#edae1a", Color.YELLOW);
										if (!wrong_target):
											PlayerVariables.num_shot["YELLOW_DUCK"] += 1;
											PlayerVariables.save_game.num_shot["YELLOW_DUCK"] += 1;
									target_spawner.white_duck_texture:
										new_shot_particles.color = Color.from_string("#dbd895", Color.WHITE);
										if (!wrong_target):
											PlayerVariables.num_shot["WHITE_DUCK"] += 1;
											PlayerVariables.save_game.num_shot["WHITE_DUCK"] += 1;
											
								if (!wrong_target):
									if (!PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("001")]):
										PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("001")] = true;
										PlayerVariables.save_game.completed_quests_values = PlayerVariables.complete_status_quests;
										
										PlayerVariables.write_to_save();
									
									PlayerVariables.num_shot_ducks += 1;
									PlayerVariables.save_game.num_shot_ducks += 1;
									
									aim_controller.duck_count += 1;
								new_points_icon.position = Vector2(434.0, 100.0);
							else:
								var target_sprite = find_child("Target");		
								
								match (target_sprite.texture):
									target_spawner.colored_target_texture:
										new_shot_particles.color = Color.from_string("#207bb0", Color.WHITE);
										if (!wrong_target):
											PlayerVariables.num_shot["COLORED_TARGET"] += 1;
											PlayerVariables.save_game.num_shot["COLORED_TARGET"] += 1;
									target_spawner.red_target_texture:
										new_shot_particles.color = Color.from_string("#cf560a", Color.DARK_RED);
										if (!wrong_target):
											PlayerVariables.num_shot["RED_TARGET"] += 1;
											PlayerVariables.save_game.num_shot["RED_TARGET"] += 1;
									target_spawner.white_target_texture:
										new_shot_particles.color = Color.WHITE;
										if (!wrong_target):
											PlayerVariables.num_shot["WHITE_TARGET"] += 1;
											PlayerVariables.save_game.num_shot["WHITE_TARGET"] += 1;
											
								if (!wrong_target):		
									if (!PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("002")]):
										PlayerVariables.complete_status_quests[PlayerVariables.save_game.completed_quests.find("002")] = true;
										PlayerVariables.save_game.completed_quests_values = PlayerVariables.complete_status_quests;
										
										PlayerVariables.write_to_save();
									
									aim_controller.target_count += 1;
									PlayerVariables.num_shot_targets += 1;
									PlayerVariables.save_game.num_shot_targets += 1;
									
								new_points_icon.position = Vector2(670.0, 100.0);
								
							shot = true;
							points_teller.reparent(canvas_layer);
							points_teller.global_position = get_viewport().get_mouse_position();
							points_teller.visible = true;
							match points:
								2:
									points_teller.modulate = Color.DEEP_SKY_BLUE;
								3:
									points_teller.modulate = Color.HOT_PINK;
								4:
									points_teller.modulate = Color.ORANGE;
								5:
									points_teller.modulate = Color.SEA_GREEN;
								7:
									points_teller.modulate = Color.YELLOW;
						if (wrong_target):
							points_teller.modulate = Color.CRIMSON;
							points_teller.text = "-" + str(points);
							hit.emit(self, -points, z_index);	
						else:
							target_spawner.number_on_screen -= 1;
							points_teller.text = "+" + str(points);
							hit.emit(self, points, z_index);
