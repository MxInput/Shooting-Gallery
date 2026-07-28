extends RichTextLabel

func _process(_delta: float) -> void:
	if (visible):
		if (modulate.a <= 0):
			queue_free();
		
		modulate.a -= .01;
		position.y -= 1;
