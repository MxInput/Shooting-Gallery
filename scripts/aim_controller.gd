extends Node2D

@export var crosshair : TextureRect;
@export var rifle : TextureRect;

func destroy_target(target, points) -> void:
	target.queue_free();
	PlayerVariables.points += points;
		
func _process(delta: float) -> void:
	var mouse_pos := crosshair.get_global_mouse_position();
	var offset := Vector2(-20, -15);
	
	crosshair.position = mouse_pos + offset;
