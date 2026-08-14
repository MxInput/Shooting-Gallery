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
@export var shot_effect : PackedScene;

var pause_manager : Node;

var game;

@export var menu : Node;

@export var blue_shot_texture : Texture2D;
@export var brown_shot_texture : Texture2D;
@export var grey_shot_texture : Texture2D;
@export var yellow_shot_texture : Texture2D;

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
		
		var new_shot_sprite := shot_effect.instantiate();
		
		if (is_in_group("duck")):
			var duck_sprite = find_child("Duck", true, false);
			
			duck_sprite.add_child(new_shot_sprite);
			
			new_shot_sprite.position = Vector2(-4.0, 21.0);
			
			match (target_type):
				Target.BROWN_DUCK:
					new_shot_particles.color = Color.from_string("#a36a31", Color.SADDLE_BROWN);
					new_shot_sprite.texture = brown_shot_texture;
				Target.YELLOW_DUCK:
					new_shot_particles.color = Color.from_string("#edae1a", Color.YELLOW);
					new_shot_sprite.texture = yellow_shot_texture;
				Target.WHITE_DUCK:
					new_shot_particles.color = Color.from_string("#dbd895", Color.WHITE);
					new_shot_sprite.texture = grey_shot_texture;
		else:
			var target_sprite = find_child("Target", true, false);		
				
			target_sprite.add_child(new_shot_sprite);
			
			new_shot_sprite.global_position = get_global_mouse_position();
							
			match (target_type):
				Target.COLORED_TARGET:
					new_shot_particles.color = Color.from_string("#207bb0", Color.WHITE);
					new_shot_sprite.texture = grey_shot_texture;
				Target.RED_TARGET:
					new_shot_particles.color = Color.from_string("#cf560a", Color.DARK_RED);
					new_shot_sprite.texture = grey_shot_texture;
				Target.WHITE_TARGET:
					new_shot_particles.color = Color.WHITE;							
					new_shot_sprite.texture = grey_shot_texture;
		hit.emit(chosen_location, self);
		
