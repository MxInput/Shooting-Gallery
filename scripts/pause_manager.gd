extends Node

var paused := false;

@export var delay_timer : Timer;

@export var countdown_timer : Timer;
@export var pause_button : Button;

@export var target_spawner : Node;
@export var duck_timer : Timer;
@export var target_timer : Timer;

@export var return_button : Button;

var delaying := false;

func pause() -> void:
	paused = true;

func unpause() -> void:
	paused = false;
	
func is_paused() -> bool:
	return paused;
	
func _input(event: InputEvent) -> void:
	if (event.is_action("pause")):
		var game_timer := target_spawner.find_child("GameTimer");
		if (game_timer != null):	
			if (!game_timer.is_stopped()):
				if (!delaying):
					delaying = true;
					delay_timer.start();
					if (!paused):
						return_button.visible = true;
						paused = true;
						
						game_timer.paused = true;
						target_timer.paused = true;
						duck_timer.paused = true;
					else:
						countdown_timer.start();
						pause_button.visible = false;
		else:
			if (target_spawner.started):
				if (!delaying):
					delaying = true;
					delay_timer.start();
					if (!paused):
						return_button.visible = true;
						paused = true;

					else:
						countdown_timer.start();
						pause_button.visible = false;

func _on_pause_button_down() -> void:
	if (!paused):
		return_button.visible = true;
		paused = true;
		
		var game_timer := target_spawner.find_child("GameTimer");
		var intermission_timer := target_spawner.find_child("IntermissionTimer");
		if (game_timer != null):
			game_timer.paused = true;
			
		if (target_timer != null):
			target_timer.paused = true;
		if (duck_timer != null):
			duck_timer.paused = true;
		if (intermission_timer != null):
			intermission_timer.paused = true;
	else:
		countdown_timer.start();
		pause_button.visible = false;

func _on_delay_timer_timeout() -> void:
	delaying = false;
