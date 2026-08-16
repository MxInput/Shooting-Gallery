extends Node2D

@export var crosshair : TextureRect;
var blocked = false;

func _ready() -> void:
	crosshair.modulate = PlayerVariables.target_color;
	crosshair.texture = PlayerVariables.cross_hair_texture;

func _process(_delta: float) -> void:
	var mouse_pos := crosshair.get_global_mouse_position();
	var offset := Vector2(-PlayerVariables.cross_hair_texture.get_width()/2.0, -PlayerVariables.cross_hair_texture.get_height()/2.0);
	
	crosshair.position = mouse_pos + offset;
