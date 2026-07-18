extends Node

@export var target : PackedScene;

@export var colored_target_texture : Texture2D;
@export var red_target_texture : Texture2D;
@export var white_target_texture : Texture2D;

@export var delay_timer : Timer;
@export var cloud_timer : Timer;
@export var game_timer : Timer;

@export var game : Node;

@export var cloud : TextureRect;
@export var cloud2 : TextureRect;

@onready var clouds = [cloud, cloud2]

enum Targets {
	RED,
	COLORED,
	WHITE
}

var target_points = [5, 7, 3];

var lower_delay_limit := 3.0;
var upper_delay_limit := 5.0;

var cloud_upper_limit := 7.0;
var cloud_lower_limit := 9.0;

func _ready() -> void:
	game_timer.start();
	
func _process(delta: float) -> void:
	if (!game_timer.is_stopped()):
		if (delay_timer.is_stopped()):
			var random_start_time := randf_range(lower_delay_limit, upper_delay_limit);
			delay_timer.wait_time = random_start_time;
			
			delay_timer.start();
		if (cloud_timer.is_stopped()):
			var selected_time = randf_range(cloud_upper_limit, cloud_lower_limit);
			cloud_timer.start();

func _on_delay_timer_timeout() -> void:
	var new_target := target.instantiate();
	game.add_child(new_target);
	
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
	cloud.get_parent().add_child(selected_cloud)
	selected_cloud.visible = true;
