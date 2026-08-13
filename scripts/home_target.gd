extends Node2D

var points := 0;
signal hit(picked_location, target);

var moving_up := true;
var original_y;

var moving_right := true;
var original_x;

var distance := 10.0;
var distance_x := 20.0;

var upper_speed := 5.0;
var lower_speed := 1.0;

var end_pos := -700.0;

var speed = randf_range(lower_speed, upper_speed);

var shot := false;

var time_till_destory := 2.0;
var time_left := 0.0;

var canvas_layer : CanvasLayer;

@export var shot_particles : PackedScene;

var pause_manager : Node;

var game;

@export var menu : Node;

enum Location {
	HUNTING,
	TIMED,
	PERFECT,
	BURSTS,
	CUSTOMIZE,
	INFO
}

enum Target {
	YELLOW_DUCK,
	WHITE_DUCK,
	BROWN_DUCK,
	RED_TARGET,
	COLORED_TARGET,
	WHITE_TARGET
}

@export var chosen_location : Location;
@export var target_type : Target;

func _ready() -> void:
	hit.connect(menu.transition);
	
	original_y = position.y;
	original_x = position.x;
			
func _process(_delta: float) -> void:	
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
					
		if (original_x != null):
			if (moving_right):
				position.x += 1;
				
				if (position.x >= original_x + distance_x):
					moving_right = false;
			else:
				position.x -= 1;
				
				if (position.x <= original_x - distance_x):
					moving_right = true;
		
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event.is_action("left_click")):
		var new_shot_particles := shot_particles.instantiate();
		add_child(new_shot_particles);
		new_shot_particles.emitting = true;
		new_shot_particles.global_position = get_global_mouse_position();
		
		if (is_in_group("duck")):
			var duck_sprite = find_child("Duck", true, false);
			match (target_type):
				Target.BROWN_DUCK:
					new_shot_particles.color = Color.from_string("#a36a31", Color.SADDLE_BROWN);
				Target.YELLOW_DUCK:
					new_shot_particles.color = Color.from_string("#edae1a", Color.YELLOW);
				Target.WHITE_DUCK:
					new_shot_particles.color = Color.from_string("#dbd895", Color.WHITE);
		else:
			var target_sprite = find_child("Target", true, false);		
								
			match (target_type):
				Target.COLORED_TARGET:
					new_shot_particles.color = Color.from_string("#207bb0", Color.WHITE);
				Target.RED_TARGET:
					new_shot_particles.color = Color.from_string("#cf560a", Color.DARK_RED);
				Target.WHITE_TARGET:
					new_shot_particles.color = Color.WHITE;							
		hit.emit(chosen_location, self);
		
