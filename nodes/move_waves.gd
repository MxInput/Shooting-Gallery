extends Node2D

@export var front_waves : Node2D;
@export var back_waves : Node2D;

var front_moving_up : Array[bool];
var back_moving_up : Array[bool];

var front_initial_y;
var back_initial_y;

var dist = 2.0;

func _ready() -> void:
	front_initial_y = front_waves.get_children()[0].position.y;
	back_initial_y = back_waves.get_children()[0].position.y;
	
	for front_wave in front_waves.get_children():
		front_moving_up.push_back(false);
		
	for back_wave in back_waves.get_children():
		back_moving_up.push_back(false);
	
func _process(delta: float) -> void:
	var front_count := 0;
	for front_wave in front_waves.get_children():
		if (front_moving_up[front_count]):
			front_wave.position.y += 0.5;
			
			if (front_wave.position.y >= dist + front_initial_y):
				front_moving_up[front_count] = false;
		else:
			front_wave.position.y -= 0.5;
		
			if (front_wave.position.y <= front_initial_y - dist):
				front_moving_up[front_count] = true;
		front_count += 1;
