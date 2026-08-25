extends TextureRect

var is_expanding := false;
var initial_size : Vector2;

func _ready() -> void:
	initial_size = size;
	
func expand() -> void:
	is_expanding = true;
		
func _process(_delta: float) -> void:
	if (is_expanding):
		size = Vector2(60.0, 60.0);
		is_expanding = false;
	
	if (size > initial_size):
		size.x -= 2.2;
		size.y -= 2.2;
		
		if (size <= initial_size):
			size = initial_size;
