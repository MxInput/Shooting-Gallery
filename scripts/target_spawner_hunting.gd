extends Node

@export var target : PackedScene;
@export var duck : PackedScene;

@export var colored_target_texture : Texture2D;
@export var red_target_texture : Texture2D;
@export var white_target_texture : Texture2D;

@export var brown_duck_texture : Texture2D;
@export var yellow_duck_texture : Texture2D;
@export var white_duck_texture : Texture2D;

@export var delay_timer : Timer;
@export var cloud_timer : Timer;
@export var duck_timer : Timer;
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

@export var time_till_change : RichTextLabel;

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

@export var crosses : Control;
@export var cross1 : TextureRect;
@export var cross2 : TextureRect;
@export var cross3 : TextureRect;

@export var cross_texture : Texture2D;

@export var target_display : TextureRect;
@export var entire_target_display : Control;

var lives := 3;
var chosen_hit := "";
var chosen_type := "";

var num_cycles := 0;
var lower_target_cycle := 4;
var upper_target_cycle := 8;

var target_cycle := 0;

var menu = "res://nodes/menu.tscn";

var time_ongoing := 0.0;
var current_cycle = 0;
var change_times = [30.0, 90.0, 160.0, 240.0];
var lower_target_cycles = [4, 3, 2, 1];
var upper_target_cycles = [8, 7, 6, 5];

var number_on_screen := 0;
var max_on_screen := 3;

var first_time = true;

var color_change_time := 0.0

var last_spawn := "";
var last_spawn_type := "";
var num_spawn := 0;

@export var pause_manager : Node;
@export var pause_button : TextureButton;

var started = false;

var ended := false;

func generate_random_hit_object() -> void:
	time_till_change.visible = false;
	time_till_change.modulate = Color.WHITE;
	time_till_change.text = "1.000s";
	color_change_time = 0.0;
	number_on_screen = 0;
	
	var found_chosen;
	
	var chance = randi_range(0, 1);
	match (chance):
		0:
			chosen_hit = generate_random_duck();
			
			if (num_spawn >= 1):
				while (chosen_hit == last_spawn && chosen_type == last_spawn_type):
					chosen_hit = generate_random_duck();
					
			chosen_type = "Duck";
			match (chosen_hit):
				"YELLOW":
					target_display.texture = yellow_duck_texture;
				"BROWN":
					target_display.texture = brown_duck_texture;
				"WHITE":
					target_display.texture = white_duck_texture;	
		1:
			chosen_hit = generate_random_target();
			
			if (num_spawn >= 1):
				while (chosen_hit == last_spawn && chosen_type == last_spawn_type):
					chosen_hit = generate_random_target();
					
			chosen_type = "Target";
			match (chosen_hit):
				"RED":
					target_display.texture = red_target_texture;
				"COLORED":
					target_display.texture = colored_target_texture;
				"WHITE":
					target_display.texture = white_target_texture;

	if (first_time):
		first_time = false;
	else:
		if (chosen_type == "Duck"):	
			match (chosen_hit):
				"YELLOW":
					found_chosen = spawned_targets["YELLOW_DUCK"];
				"BROWN":
					found_chosen = spawned_targets["BROWN_DUCK"];
				"WHITE":
					found_chosen = spawned_targets["WHITE_DUCK"];
					
			for found_chosen_duck in found_chosen:
				if (is_instance_valid(found_chosen_duck)):
					var duck_sprite = found_chosen_duck.find_child("Duck", true, false);
					var new_duck = Ducks.keys().pick_random();
						
					while (new_duck == chosen_hit):
						new_duck = Ducks.keys().pick_random();
							
					duck_sprite.texture = duck_textures[Ducks.values()[Ducks.keys().find(new_duck)]]
					found_chosen_duck.points = duck_points[Ducks.values()[Ducks.keys().find(new_duck)]];
		else:
			match (chosen_hit):
				"RED":
					found_chosen = spawned_targets["RED_TARGET"];
				"COLORED":
					found_chosen = spawned_targets["COLORED_TARGET"];
				"WHITE":
					found_chosen = spawned_targets["WHITE_TARGET"];
					
			for found_chosen_target in found_chosen:
				if (is_instance_valid(found_chosen_target)):
					var target_sprite = found_chosen_target.find_child("Target", true, false);
					var new_target = Targets.keys().pick_random();
						
					while (new_target == chosen_hit):
						new_target = Targets.keys().pick_random();
							
					target_sprite.texture = target_textures[Targets.values()[Targets.keys().find(new_target)]]
					found_chosen_target.points = target_points[Targets.values()[Targets.keys().find(new_target)]];
	
	if (last_spawn == chosen_hit && last_spawn_type == chosen_type):
		num_spawn += 1;
	else:
		last_spawn = chosen_hit;
		last_spawn_type = chosen_type;
		num_spawn = 0;
			
func generate_random_duck() -> String:
	var duck_arr = Ducks.keys();
	var chosen_duck = duck_arr.pick_random();
	return chosen_duck;
	
func generate_random_target() -> String:
	var target_arr = Targets.keys();
	var chosen_target = target_arr.pick_random();
	return chosen_target;
	
func updateLives() -> void:
	if (lives == 2):
		cross1.texture = cross_texture;
	elif (lives == 1):
		cross2.texture = cross_texture;
	elif (lives == 0):
		cross3.texture = cross_texture;
		
func _ready() -> void:
	PlayerVariables.game_last_played = "Hunting";
	countdown_timer.start();
	
func round_to_dec(num, place) -> float:
	return round(num * pow(10.0, place)) / pow(10.0, place);
	
func _process(delta: float) -> void:
	if (!first_time):
		if (num_cycles == target_cycle):
			var time_left_countdown;
			
			if (chosen_type == "Duck"):
				time_left_countdown = duck_timer.time_left;
			else:
				time_left_countdown = delay_timer.time_left;
			
			if (time_left_countdown < 1.00 && time_left_countdown > 0.0):
				var target_color := Color.RED;
				color_change_time += delta/12.0;
				color_change_time = clampf(color_change_time, 0.0, 1.0)
				
				time_till_change.visible = true;
				time_till_change.text = str(round_to_dec(time_left_countdown, 3)) + "s";
				time_till_change.modulate = lerp(time_till_change.modulate, target_color, color_change_time);
			
	if (lives == 0):
		if (!ended):
			ended = true;
			
			if (PlayerVariables.points > PlayerVariables.high_score_hunting):
				PlayerVariables.high_score_hunting = PlayerVariables.points;
				
			PlayerVariables.num_shot_ducks_comp += PlayerVariables.num_shot_ducks;
			PlayerVariables.num_shot_targets_comp += PlayerVariables.num_shot_targets;
			
			PlayerVariables.completed_last_game = true;
			
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
		
	if (lives > 0):
		time_ongoing += delta;
		
		if (delay_timer.is_stopped()):
			var random_start_time := randf_range(lower_delay_limit, upper_delay_limit);
			delay_timer.wait_time = random_start_time;
			
			delay_timer.start();
		if (duck_timer.is_stopped()):
			var random_start_time := randf_range(lower_duck_limit, upper_duck_limit);
			duck_timer.wait_time = random_start_time;
			
			duck_timer.start();
		if (cloud_timer.is_stopped()):
			var selected_time = randf_range(cloud_upper_limit, cloud_lower_limit);
			cloud_timer.wait_time = selected_time;
			cloud_timer.start();
			
func _on_delay_timer_timeout() -> void:
	if (chosen_type == "Target"):
		num_cycles += 1;
		
	if (num_cycles > target_cycle):
		target_cycle = randi_range(lower_target_cycle, upper_target_cycle);
		num_cycles = 0;
		generate_random_hit_object();
		
	var new_target := target.instantiate();
	game.add_child(new_target);
	new_target.position.x = 550.0;
	new_target.position.y = randf_range(lower_target_spawn, upper_target_spawn);
	new_target.original_y = new_target.position.y;
	new_target.z_index = randi_range(2, 4);
	
	var selected_target_value = Targets.keys().pick_random();
	
	match (selected_target_value):
		"RED":
			number_on_screen = spawned_targets["RED_TARGET"].size();
		
		"COLORED":
			new_target.find_child("Target").texture = colored_target_texture;
			spawned_targets["COLORED_TARGET"].push_back(new_target);
			
		"WHITE":
			new_target.find_child("Target").texture = white_target_texture;
			spawned_targets["WHITE_TARGET"].push_back(new_target);
	
	if (chosen_type == "Target" && chosen_hit == selected_target_value):	
		if (number_on_screen >= max_on_screen):
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
	
func _on_cloud_timer_timeout() -> void:
	var selected_cloud = clouds.pick_random().duplicate();
	var y_pos = randf_range(cloud_lower_y, cloud_upper_y);
	
	canvas_layer.add_child(selected_cloud)
	cloud.position.y = y_pos;
	selected_cloud.visible = true;

func _on_duck_timer_timeout() -> void:
	if (chosen_type == "Duck"):
		num_cycles += 1;
		
	if (num_cycles > target_cycle):
		target_cycle = randi_range(lower_target_cycle, upper_target_cycle);
		num_cycles = 0;
		generate_random_hit_object();
		
	var new_duck := duck.instantiate();
	game.add_child(new_duck);
	new_duck.position.x = 550.0;
	
	var selected_duck_value = Ducks.keys().pick_random();
	
	if (chosen_type == "Duck" && chosen_hit == selected_duck_value):	
		if (number_on_screen < max_on_screen):
			number_on_screen += 1;
		else:
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
	
func _on_countdown_timer_timeout() -> void:
	if (!started):
		started = true;
		entire_target_display.visible = true;
		
		target_cycle = randi_range(lower_target_cycle, upper_target_cycle);
		generate_random_hit_object();
	else:
		delay_timer.paused = false;
		duck_timer.paused = false;
		pause_manager.unpause();
		return_button.visible = false;

	pause_button.visible = true;
	go.visible = false;
	

func _on_return_button_down() -> void:
	get_tree().change_scene_to_file(menu);
