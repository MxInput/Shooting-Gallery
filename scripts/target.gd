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
			queue_free();
	else:
		time_left += delta;
		
		if (time_left >= time_till_destory):
			queue_free();
		
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var aim_controller = get_parent().find_child("AimController");
	if (event.is_action("left_click")):
		if (!shot):
			if (aim_controller.loaded):	
				if (is_in_group("duck")):
					aim_controller.duck_count += 1;
				else:
					aim_controller.target_count += 1;
					
				shot = true;
				points_teller.text = "+" + str(points);
				points_teller.reparent(canvas_layer);
				points_teller.global_position = get_viewport().get_mouse_position();
				points_teller.visible = true;
			hit.emit(self, points);
			
