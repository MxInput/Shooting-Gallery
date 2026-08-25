extends Node

@export var target : PackedScene;
@export var duck : PackedScene;

@export var colored_target_texture : Texture2D;
@export var red_target_texture : Texture2D;
@export var white_target_texture : Texture2D;

@export var brown_duck_texture : Texture2D;
@export var yellow_duck_texture : Texture2D;
@export var white_duck_texture : Texture2D;

@export var cloud_timer : Timer;
@export var countdown_timer : Timer;

@export var game : Node;
@export var aim_controller : Node;

@export var cloud : TextureRect;
@export var cloud2 : TextureRect;

@onready var clouds = [cloud, cloud2]

@export var game_over : TextureRect;
@export var start : TextureRect;
@export var go : TextureRect;

@export var return_button : TextureButton;

enum Targets {
	RED,
	COLORED,
	WHITE
}

enum Ducks {
	YELLOW,
	BROWN,
	WHITE
}

var spawned_targets = {
	"YELLOW_DUCK": [],
	"BROWN_DUCK": [],
	"WHITE_DUCK": [],
	"WHITE_TARGET": [],
	"COLORED_TARGET": [],
	"RED_TARGET": []
}

var target_points = [5, 7, 3];
@onready var target_textures = [red_target_texture, colored_target_texture, white_target_texture];

var duck_points = [2, 3, 4];
@onready var duck_textures = [yellow_duck_texture, brown_duck_texture, white_duck_texture];

var lower_duck_limit := 1.0;
var upper_duck_limit := 2.0;

var lower_delay_limit := 2.0;
var upper_delay_limit := 3.0;

var cloud_upper_limit := 1.0;
var cloud_lower_limit := 3.0;

var cloud_lower_y := 111.0;
var cloud_upper_y := 180.0;

var lower_target_spawn := -140.0;
var upper_target_spawn := -200.0;

@export var canvas_layer : CanvasLayer;

var waves_remaining := 0;
var max_waves := 3;
var chosen_hit := "";
var chosen_type := "";

var num_cycles := 0;
var lower_target_cycle := 4;
var upper_target_cycle := 8;

var target_cycle := 0;

var spawns_now := 0;
var spawns_possible := 0;
var spawns_range := [22, 30];

var menu = "res://nodes/menu.tscn";

var time_ongoing := 0.0;
var current_cycle = 0;
var change_times = [30.0, 90.0, 160.0, 240.0];
var lower_target_cycles = [4, 3, 2, 1];
var upper_target_cycles = [8, 7, 6, 5];

var number_on_screen := 0;
var max_on_screen := 8;

var first_time = true;

var color_change_time := 0.0

var last_spawn := "";
var last_spawn_type := "";

@export var pause_manager : Node;
@export var pause_button : TextureButton;

var started = false;

var already_spawned = false;
var finished_spawning = false;

var duck_clock := 0.0;
var duck_activate_time := 0.8;
var target_clock := 0.0;
var target_activate_time := 1.2;

signal duck_done
signal target_done

@export var wave_display : RichTextLabel;

var lower_speeds = [7.0, 7.5, 8.0, 8.5]
var upper_speeds = [8.0, 8.5, 9.0, 9.5]
 
@export var intermission_timer : Timer;

var ended := false;

func generate_wave() -> void:
	already_spawned = true;
	while (spawns_now < spawns_possible):
		await generate_random_hit_object();
	finished_spawning = true;
		
func generate_random_hit_object() -> void:
	color_change_time = 0.0;
	number_on_screen = 0;
	
	var chance = randi_range(0, 1);

	match (chance):
		0:
			chosen_type = "Duck";
			
			if (duck_clock < duck_activate_time):
				await duck_done;
				
			if (spawns_now >= spawns_possible):
				return;
				
			duck_activate();
		1:
			chosen_type = "Target";
			
			if (target_clock < target_activate_time):
				await target_done;
			
			if (spawns_now >= spawns_possible):
				return;
				
			delay_activate();				

	if (first_time):
		first_time = false;
		
	last_spawn = chosen_hit;
	last_spawn_type = chosen_type;
	
func generate_random_duck() -> String:
	var duck_arr = Ducks.keys();
	var chosen_duck = duck_arr.pick_random();
	return chosen_duck;
	
func generate_random_target() -> String:
	var target_arr = Targets.keys();
	var chosen_target = target_arr.pick_random();
	return chosen_target;
		
func _ready() -> void:
	PlayerVariables.game_last_played = "Burst";
	PlayerVariables.save_game.game_last_played = PlayerVariables.game_last_played;
	
	PlayerVariables.write_to_save();

	countdown_timer.start();

func round_to_dec(num, place) -> float:
	return round(num * pow(10.0, place)) / pow(10.0, place);
	
func _process(delta: float) -> void:
	if (started && waves_remaining <= max_waves && !pause_manager.is_paused()):
		if (already_spawned && finished_spawning):
			var targets_arrs = spawned_targets.values();
			var target_arrs_size = 0;
			var total_count = 0;
			
			for target_arr in targets_arrs:
				var current_arr_count = target_arr.size();
				
				target_arrs_size += 1;
				total_count += current_arr_count;

				if (target_arrs_size == targets_arrs.size()):
					if (total_count == 0):
						waves_remaining += 1; 
						if (waves_remaining <= max_waves):
							wave_display.text = "WAVE " + str(waves_remaining + 1);
							spawns_now = 0;
							spawns_possible = randi_range(spawns_range[0], spawns_range[1]);
							
							already_spawned = false;
							finished_spawning = false;
							
							intermission_timer.start();
						else:
							wave_display.text = "END";			
					
		if (duck_clock < duck_activate_time):
			duck_clock += delta;
		else:
			duck_done.emit();
		if (target_clock < target_activate_time):
			target_clock += delta;
		else:
			target_done.emit();
			
	if (waves_remaining > max_waves):
		if (!ended):
			ended = true;
			if (PlayerVariables.points > PlayerVariables.high_score_burst):
				PlayerVariables.high_score_burst = PlayerVariables.points;
				PlayerVariables.save_game.high_score_burst = PlayerVariables.high_score_burst;

			PlayerVariables.num_shot_ducks_comp += PlayerVariables.num_shot_ducks;
			PlayerVariables.save_game.num_shot_ducks_comp += PlayerVariables.num_shot_ducks;

			PlayerVariables.num_shot_targets_comp += PlayerVariables.num_shot_targets;
			PlayerVariables.save_game.num_shot_targets_comp += PlayerVariables.num_shot_targets;

			PlayerVariables.completed_last_game = true;
			PlayerVariables.save_game.completed_last_game = true;

			pause_button.visible = false;
			return_button.visible = true;
			
			game_over.visible = true;
			
			PlayerVariables.write_to_save();

	if (current_cycle < change_times.size()):
		if (time_ongoing >= change_times[current_cycle]):
			current_cycle += 1;
			lower_target_cycle = lower_target_cycles[current_cycle];
			upper_target_cycle = upper_target_cycles[current_cycle];
		
	if (!countdown_timer.is_stopped()):
		var time_left := countdown_timer.time_left;
		if (time_left <= 1.0):
			start.visible = false;
			go.visible = true;
		else:
			start.visible = true;
		
	if (waves_remaining < max_waves):
		time_ongoing += delta;
		
		if (cloud_timer.is_stopped()):
			var selected_time = randf_range(cloud_upper_limit, cloud_lower_limit);
			cloud_timer.wait_time = selected_time;
			cloud_timer.start();
			
func delay_activate() -> void:
	target_clock = 0.0;
	if (chosen_type == "Target"):
		num_cycles += 1;
		
	var new_target := target.instantiate();
	game.add_child(new_target);
	new_target.position.x = 550.0;
	new_target.position.y = randf_range(lower_target_spawn, upper_target_spawn);
	new_target.original_y = new_target.position.y;
	new_target.z_index = randi_range(2, 4);
	
	var selected_target_value = Targets.keys().pick_random();
	chosen_hit = selected_target_value;
	
	var target_array;
			
	match (selected_target_value):
		"RED":
			target_array = spawned_targets["RED_TARGET"];
		"COLORED":
			target_array = spawned_targets["COLORED_TARGET"];
		"WHITE":
			target_array = spawned_targets["WHITE_TARGET"];
					
	if (target_array.size() >= max_on_screen):
		while (selected_target_value == chosen_hit):
			selected_target_value = Targets.keys().pick_random();
				
	match (selected_target_value):
		"RED":
			new_target.find_child("Target").texture = red_target_texture;
			spawned_targets["RED_TARGET"].push_back(new_target);
		
		"COLORED":
			new_target.find_child("Target").texture = colored_target_texture;
			spawned_targets["COLORED_TARGET"].push_back(new_target);
			
		"WHITE":
			new_target.find_child("Target").texture = white_target_texture;
			spawned_targets["WHITE_TARGET"].push_back(new_target);
			
	new_target.points = target_points[Targets.values()[Targets.keys().find(selected_target_value)]]
	spawns_now += 1;
	
func _on_cloud_timer_timeout() -> void:
	var selected_cloud = clouds.pick_random().duplicate();
	var y_pos = randf_range(cloud_lower_y, cloud_upper_y);"text"
	
	canvas_layer.add_child(selected_cloud)
	cloud.position.y = y_pos;
	selected_cloud.visible = true;

func duck_activate() -> void:
	duck_clock = 0.0;
	if (chosen_type == "Duck"):
		num_cycles += 1;
		
	var new_duck := duck.instantiate();
	game.add_child(new_duck);
	new_duck.position.x = 550.0;
	
	var selected_duck_value = Ducks.keys().pick_random();
	chosen_hit = selected_duck_value;
	
	var target_array;
			
	match (selected_duck_value):
		"YELLOW":
			target_array = spawned_targets["YELLOW_DUCK"];
		"BROWN":
			target_array = spawned_targets["BROWN_DUCK"];
		"WHITE":
			target_array = spawned_targets["WHITE_DUCK"];
					
	if (target_array.size() >= max_on_screen):
		while (selected_duck_value == chosen_hit):
			selected_duck_value = Ducks.keys().pick_random();

	match (selected_duck_value):
		"YELLOW":
			new_duck.find_child("Duck").texture = yellow_duck_texture;
			spawned_targets["YELLOW_DUCK"].push_back(new_duck);
		"BROWN":
			new_duck.find_child("Duck").texture = brown_duck_texture;
			spawned_targets["BROWN_DUCK"].push_back(new_duck);
		"WHITE":
			new_duck.find_child("Duck").texture = white_duck_texture;
			spawned_targets["WHITE_DUCK"].push_back(new_duck);
			
	new_duck.points = duck_points[Ducks.values()[Ducks.keys().find(selected_duck_value)]];
	spawns_now += 1;
	
func _on_countdown_timer_timeout() -> void:
	if (!started):
		started = true;
		
		spawns_possible = randi_range(spawns_range[0], spawns_range[1]);
		target_cycle = randi_range(lower_target_cycle, upper_target_cycle);
		generate_wave();
		countdown_timer.wait_time = 0.5;
	else:
		pause_manager.unpause();
		return_button.visible = false;
		intermission_timer.paused = false;

	pause_button.visible = true;
	go.visible = false;

func _on_return_button_down() -> void:
	get_tree().change_scene_to_file(menu);

func _on_intermission_timer_timeout() -> void:
	generate_wave();
