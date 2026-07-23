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

@export var reload_timer : Timer;

var ammo := 3;

var max_ammo := 3;

var loaded := true;

@export var bullet_outline1 : TextureRect;
@export var bullet_outline2 : TextureRect;
@export var bullet_outline3 : TextureRect;

@export var gold_bullet : Texture2D;
@export var silver_bullet : Texture2D;

var is_hovering := false;
var is_active := false;

func destroy_target(target, points) -> void:
	if (loaded):
		var new_shot_sprite = shot_sprite.instantiate();
	
		var mouse_pos = get_global_mouse_position();
				
		if (target.is_in_group("duck")):
			var duck_object = target.find_child("Duck");
			
			match (duck_object.texture):
				target_spawner.brown_duck_texture:
					new_shot_sprite.texture = brown_shot_texture;
				target_spawner.yellow_duck_texture:
					new_shot_sprite.texture = yellow_shot_texture;
				target_spawner.white_duck_texture:
					new_shot_sprite.texture = grey_shot_texture;
					
			duck_object.add_child(new_shot_sprite);
			new_shot_sprite.position = Vector2(-4.0, 21.0);
		else:
			var target_object = target.find_child("Target");
			
			match (target_object.texture):
				target_spawner.colored_target_texture:
					new_shot_sprite.texture = grey_shot_texture;
				target_spawner.red_target_texture:
					new_shot_sprite.texture = grey_shot_texture;
				target_spawner.white_target_texture:
					new_shot_sprite.texture = grey_shot_texture;
					
			target_object.add_child(new_shot_sprite);	
			new_shot_sprite.global_position = mouse_pos;
		
		PlayerVariables.points += points;
		
		point_teller.text = "Points: " + str(PlayerVariables.points);
		
func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("left_click")):
		if (ammo == 0):
			if (reload_timer.is_stopped()):
				reload_timer.start();
				
				var animation_player : AnimationPlayer = rifle.get_child(0);
				animation_player.play("dying")
				
				bullet_outline1.get_child(0).visible = true;
				bullet_outline1.get_child(0).texture = silver_bullet;
		else:
			if (ammo == 3):
				bullet_outline3.get_child(0).visible = false;
			elif (ammo == 2):
				bullet_outline2.get_child(0).visible = false;
			elif (ammo == 1):
				bullet_outline1.get_child(0).visible = false;
				loaded = false;		
				
			ammo -= 1;
			
func _process(_delta: float) -> void:
	var mouse_pos := crosshair.get_global_mouse_position();
	var offset := Vector2(-20, -15);
	
	crosshair.position = mouse_pos + offset;
	
	if (!reload_timer.is_stopped()):
		var time_left := reload_timer.time_left;
		
		if (time_left <= 1.0):
			bullet_outline3.get_child(0).visible = true;
			bullet_outline3.get_child(0).texture = silver_bullet;
		elif (time_left <= 2.0):
			bullet_outline2.get_child(0).visible = true;
			bullet_outline2.get_child(0).texture = silver_bullet;
			
func _on_reload_timer_timeout() -> void:
	ammo = 3;
	loaded = true;
	
	bullet_outline1.get_child(0).texture = gold_bullet;
	bullet_outline2.get_child(0).texture = gold_bullet;
	bullet_outline3.get_child(0).texture = gold_bullet;
