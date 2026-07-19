extends Node2D

@export var crosshair : TextureRect;
@export var rifle : TextureRect;

@export var point_teller : RichTextLabel;

@export var blue_shot_texture : Texture2D;
@export var brown_shot_texture : Texture2D;
@export var grey_shot_texture : Texture2D;
@export var yellow_shot_texture : Texture2D;

@export var shot_sprite : PackedScene;

@export var target_spawner : Node;

func destroy_target(target, points) -> void:
	var new_shot_sprite = shot_sprite.instantiate();
	
	var mouse_pos = get_global_mouse_position();
	
	match (target.texture):
		target_spawner.colored_target_texture:
			shot_sprite.texture = grey_shot_texture;
		target_spawner.red_target_texture:
			shot_sprite.texture = grey_shot_texture;
		target_spawner.white_target_texture:
			shot_sprite.texture = grey_shot_texture;
		target_spawner.brown_duck_texture:
			shot_sprite.texture = brown_shot_texture;
		target_spawner.yellow_duck_texture:
			shot_sprite.texture = yellow_shot_texture;
		target_spawner.white_duck_texture:
			shot_sprite.texture = grey_shot_texture;
			
	if (target.is_in_group("duck")):
		target.find_child("Duck").add_child(new_shot_sprite);
		new_shot_sprite.position = Vector2(-4.0, 21.0);
	else:
		target.find_child("Target").add_child(new_shot_sprite);	
		new_shot_sprite.global_position = mouse_pos;
	
	PlayerVariables.points += points;
	
	point_teller.text = "Points: " + str(PlayerVariables.points);
		
func _process(delta: float) -> void:
	var mouse_pos := crosshair.get_global_mouse_position();
	var offset := Vector2(-20, -15);
	
	crosshair.position = mouse_pos + offset;
