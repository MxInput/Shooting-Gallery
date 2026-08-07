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
@export var game_timer : Timer;
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

@export var clock : RichTextLabel;
@export var perfect_final_text : RichTextLabel;
@export var perfect_teller : RichTextLabel;

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

@export var return_button : Button;

var menu = "res://nodes/menu.tscn";

@export var pause_manager : Node;
@export var pause_button : Button;

var color_change_time := 0.0;
var reach_30 := false;
var reach_60 := false;

var target_color

var inc_amt = 0.0;

var original_clock_size;

func _ready() -> void:
	countdown_timer.start();
	
func _process(delta: float) -> void:
	if (!countdown_timer.is_stopped()):
		var time_left := countdown_timer.time_left;
		if (time_left <= 1.0):
			start.visible = false;
			go.visible = true;
		else:
			start.visible = true;
		
	if (!game_timer.is_stopped()):
		var time_left := game_timer.time_left;
		
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
			
		var minutes := (int(time_left/60));
		var seconds := (int(time_left)%60);
				
		if (time_left <= 30.0):
			if (!reach_30):
				target_color = Color.ORANGE_RED;
				reach_30 = true;
				
				color_change_time = 0.0;
			
			color_change_time += delta/10000.0;
			color_change_time = clampf(color_change_time, 0.0, 1.0);
		
			clock.modulate = lerp(clock.modulate, target_color, color_change_time);
		elif (time_left <= 60.0):
			if (!reach_60):
				target_color = Color.ORANGE;
				reach_60 = true;
				
				color_change_time = 0.0;
				
			color_change_time += delta/10000.0;
			color_change_time = clampf(color_change_time, 0.0, 1.0);
			
			clock.modulate = lerp(clock.modulate, target_color, color_change_time);
			
		if (seconds < 10):
			clock.text = str(minutes) + ":0" + str(seconds);
		else:
			clock.text = str(minutes) + ":" + str(seconds);
			
		if (time_left < 10.0 && time_left > 0):
			inc_amt += 0.05;
			
			if (original_clock_size == null):
				original_clock_size = clock.get_theme_font_size("normal_font_size");
			
			var new_font_size = int(original_clock_size + inc_amt);
			
			clock.add_theme_font_size_override("normal_font_size", new_font_size);

func _on_delay_timer_timeout() -> void:
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

func _on_game_timer_timeout() -> void:
	PlayerVariables.game_last_played = "Timed";
	if (PlayerVariables.points > PlayerVariables.high_score_timed):
		PlayerVariables.high_score_timed = PlayerVariables.points;
		
	return_button.visible = true;
	game_over.visible = true;
	if (perfect_teller.visible):
		perfect_final_text.visible = true;

func _on_countdown_timer_timeout() -> void:
	if (!game_timer.paused):
		game_timer.start();
	else:
		game_timer.paused = false;
		delay_timer.paused = false;
		duck_timer.paused = false;
		return_button.visible = false;
		pause_manager.unpause();
		
	pause_button.visible = true;
	go.visible = false;
	
func _on_return_button_down() -> void:
	get_tree().change_scene_to_file(menu);
