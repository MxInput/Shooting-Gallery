extends Node2D

var points := 0;
signal hit(obj, point_value);

var moving_up = true;
var original_y;

var distance := 10.0;

var upper_speed := 5.0;
var lower_speed := 1.0;

var end_pos := -700.0;

var speed = randf_range(lower_speed, upper_speed);

var shot := false;

var time_till_destory := 2.0;
var time_left := 0.0;

@onready var points_teller := find_child("Points");

var canvas_layer : CanvasLayer;

@export var points_icon : PackedScene;
@export var shot_particles : PackedScene;

func _ready() -> void:
	var aim_controller = get_parent().find_child("AimController");
	hit.connect(aim_controller.destroy_target);
	
	var game = get_parent();
	canvas_layer = game.find_child("CanvasLayer");

func _process(delta: float) -> void:	
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
			var target_spawner = get_parent().find_child("TargetSpawner");
			if (!target_spawner.game_timer.is_stopped()):
				var perfect_text := canvas_layer.find_child("PerfectTeller");
				perfect_text.visible = false;
			queue_free();
	else:
		time_left += delta;
		
		if (time_left >= time_till_destory):
			queue_free();
		
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var aim_controller = get_parent().find_child("AimController");
	var target_spawner = get_parent().find_child("TargetSpawner");
	if (!target_spawner.game_timer.is_stopped()):
		if (event.is_action("left_click")):
			if (!shot):
				if (aim_controller.loaded):	
					var new_points_icon = points_icon.instantiate();
					canvas_layer.add_child(new_points_icon);
					if (is_in_group("duck")):
						aim_controller.duck_count += 1;
						new_points_icon.position = Vector2(434.0, 100.0);
					else:
						aim_controller.target_count += 1;
						new_points_icon.position = Vector2(678.0, 100.0);
						
					var new_shot_particles := shot_particles.instantiate();
					add_child(new_shot_particles);
					new_shot_particles.emitting = true;
					new_shot_particles.global_position = get_global_mouse_position();
					
					match (texture):
						target_spawner.colored_target_texture:
							new_shot_sprite.texture = grey_shot_texture;
						target_spawner.red_target_texture:
							new_shot_sprite.texture = grey_shot_texture;
						target_spawner.white_target_texture:
							new_shot_sprite.texture = grey_shot_texture;
						
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
				hit.emit(self, points);
			
