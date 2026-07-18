extends Node2D

var points := 0;

signal hit(obj, point_value);

func _ready() -> void:
	var aim_controller = self.get_parent().find_child("AimController");
	hit.connect(aim_controller.destroy_target);
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action("left_click")):
		hit.emit(self, points);
