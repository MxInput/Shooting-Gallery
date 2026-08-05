extends Node

var paused := false;

@export var countdown_timer : Timer;
@export var pause_button : Button;

func pause() -> void:
	paused = true;

func unpause() -> void:
	paused = false;
	
func is_paused() -> bool:
	return paused;

func _on_pause_button_down() -> void:
	if (!paused):
		paused = true;
	else:
		countdown_timer.start();
		pause_button.visible = false;
