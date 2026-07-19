extends TextureRect

func _process(delta: float) -> void:
	if (visible):
		position.x -= 1.5;
		if (position.x < -390):
			queue_free();
