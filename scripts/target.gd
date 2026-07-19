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

var upper_pos = -120.0;

var shot := false;

func _ready() -> void:
	var aim_controller = self.get_parent().find_child("AimController");
	hit.connect(aim_controller.destroy_target);
	
	if (is_in_group("target")):
		position.y = upper_pos;
		
	original_y = position.y;

func _process(delta: float) -> void:	
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
			
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action("left_click")):
		if (!shot):
			hit.emit(self, points);
			shot = true;
