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

@export var return_button : Button;

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

var target_points = [5, 7, 3];
var duck_points = [2, 3, 4];

var lower_duck_limit := 2.0;
var upper_duck_limit := 3.0;

var lower_delay_limit := 3.0;
var upper_delay_limit := 5.0;

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

var finished := false;

var menu = "res://nodes/menu.tscn";

func generate_random_hit_object() -> void:
	var chance = randi_range(0, 1);
	match (chance):
		0:
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
			chosen_type = "Target";
			match (chosen_hit):
				"RED":
					target_display.texture = red_target_texture;
				"COLORED":
					target_display.texture = colored_target_texture;
				"WHITE":
					target_display.texture = white_target_texture;

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
	countdown_timer.start();
	
func _process(_delta: float) -> void:
	if (lives == 0):
		PlayerVariables.game_last_played = "Hunting";

		if (PlayerVariables.points > PlayerVariables.high_score_hunting):
			PlayerVariables.high_score_hunting = PlayerVariables.points;
		
		finished = true;
		game_over.visible = true;
		return_button.visible = true;
		
	if (!countdown_timer.is_stopped()):
		var time_left := countdown_timer.time_left;
		if (time_left <= 1.0):
			start.visible = false;
			go.visible = true;
		else:
			start.visible = true;
		
	if (lives > 0):
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
			new_target.find_child("Target").texture = red_target_texture;
		"COLORED":
			new_target.find_child("Target").texture = colored_target_texture;
		"WHITE":
			new_target.find_child("Target").texture = white_target_texture;
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
	
	match (selected_duck_value):
		"YELLOW":
			new_duck.find_child("Duck").texture = yellow_duck_texture;
		"BROWN":
			new_duck.find_child("Duck").texture = brown_duck_texture;
		"WHITE":
			new_duck.find_child("Duck").texture = white_duck_texture;
	new_duck.points = duck_points[Ducks.values()[Ducks.keys().find(selected_duck_value)]];

func _on_countdown_timer_timeout() -> void:
	entire_target_display.visible = true;
	go.visible = false;
	
	target_cycle = randi_range(lower_target_cycle, upper_target_cycle);
	generate_random_hit_object();


func _on_return_button_down() -> void:
	get_tree().change_scene_to_file(menu);
