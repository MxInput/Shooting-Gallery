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
@export var delay_timer : Timer;

var ammo := 6;

var max_ammo := 6;

var loaded := true;

@export var bullet_outline1 : TextureRect;
@export var bullet_outline2 : TextureRect;
@export var bullet_outline3 : TextureRect;
@export var bullet_outline4 : TextureRect;
@export var bullet_outline5 : TextureRect;
@export var bullet_outline6 : TextureRect;

@export var gold_bullet : Texture2D;
@export var silver_bullet : Texture2D;

var is_hovering := false;
var is_active := false;

var duck_count := 0;
var target_count := 0;

var combo := 0;
@export var combo_teller : RichTextLabel;
@export var combo_timer : Timer;
@export var disappear_timer : Timer;

@export var duck_count_text : RichTextLabel;
@export var target_count_text : RichTextLabel;

var bullet_6_reload_time := 0.05;
var bullet_5_reload_time := 0.10;
var bullet_4_reload_time := 0.15;
var bullet_3_reload_time := 0.20;
var bullet_2_reload_time := 0.25;
var bullet_1_reload_time := 0.30;

var blocked := false;

@export var initial_timer : Timer;

@export var points_icon : PackedScene;
@export var canvas_layer : CanvasLayer;

@export var pause_manager : Node;

func destroy_target(target, points, order) -> void:
	if (loaded && (!blocked || order != 2)):
		if (target_spawner.waves_remaining <= target_spawner.max_waves):
			if (combo_timer.is_stopped()):
				combo = 0;
				combo_timer.start();
			else:	
				combo += 1;
			
			if (combo >= 1):
					var combo_additive = (1 + (combo * 0.25));
					combo_teller.text = "[tornado freq=" + str(combo_additive) + "]x" + str(combo+1) + " COMBO";
					combo_teller.visible = true;
					disappear_timer.start();
				
			var new_shot_sprite = shot_sprite.instantiate();
		
			var mouse_pos = get_global_mouse_position();
					
			if (target.is_in_group("duck")):
				duck_count_text.text = str(duck_count);
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
				target_count_text.text = str(target_count);
				
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
			
			if (PlayerVariables.points < 0):
				PlayerVariables.points = 0;

			point_teller.text = str(PlayerVariables.points);
			
func _ready() -> void:
	initial_timer.start();	
	crosshair.modulate = PlayerVariables.target_color;	
	crosshair.texture = PlayerVariables.cross_hair_texture;
	
func _process(_delta: float) -> void:
	if (!pause_manager.is_paused()):
		if (initial_timer.is_stopped()):
			if (Input.is_action_pressed("left_click")):
				if (target_spawner.waves_remaining <= target_spawner.max_waves):
					if (delay_timer.is_stopped()):
						delay_timer.start();
						if (ammo == 0):
							if (reload_timer.is_stopped()):
								reload_timer.start();
								
								var animation_player : AnimationPlayer = rifle.get_child(0);
								animation_player.play("dying")
								
								bullet_outline1.get_child(0).visible = true;
								bullet_outline1.get_child(0).texture = silver_bullet;
						else:
							if (ammo == 6):
								bullet_outline6.get_child(0).visible = false;
							elif (ammo == 5):
								bullet_outline5.get_child(0).visible = false;
							elif (ammo == 4):
								bullet_outline4.get_child(0).visible = false;
							elif (ammo == 3):
								bullet_outline3.get_child(0).visible = false;
							elif (ammo == 2):
								bullet_outline2.get_child(0).visible = false;
							elif (ammo == 1):
								bullet_outline1.get_child(0).visible = false;
								loaded = false;		
								
							ammo -= 1;
		
		if (!reload_timer.is_stopped()):
			var time_left := reload_timer.time_left;
			
			if (time_left <= bullet_6_reload_time):
				bullet_outline6.get_child(0).visible = true;
				bullet_outline6.get_child(0).texture = silver_bullet;
			if (time_left <= bullet_5_reload_time):
				bullet_outline5.get_child(0).visible = true;
				bullet_outline5.get_child(0).texture = silver_bullet;
			if (time_left <= bullet_4_reload_time):
				bullet_outline4.get_child(0).visible = true;
				bullet_outline4.get_child(0).texture = silver_bullet;
			if (time_left <= bullet_3_reload_time):
				bullet_outline3.get_child(0).visible = true;
				bullet_outline3.get_child(0).texture = silver_bullet;
			elif (time_left <= bullet_2_reload_time):
				bullet_outline2.get_child(0).visible = true;
				bullet_outline2.get_child(0).texture = silver_bullet;
	
	var mouse_pos := crosshair.get_global_mouse_position();
	var offset := Vector2(-PlayerVariables.cross_hair_texture.get_width()/2.0, -PlayerVariables.cross_hair_texture.get_height()/2.0);

	crosshair.position = mouse_pos + offset;
	
func _on_reload_timer_timeout() -> void:
	ammo = max_ammo;
	loaded = true;
	
	bullet_outline1.get_child(0).texture = gold_bullet;
	bullet_outline2.get_child(0).texture = gold_bullet;
	bullet_outline3.get_child(0).texture = gold_bullet;
	bullet_outline4.get_child(0).texture = gold_bullet;
	bullet_outline5.get_child(0).texture = gold_bullet;
	bullet_outline6.get_child(0).texture = gold_bullet;
	
func _on_disappear_timer_timeout() -> void:
	combo_teller.visible = false;

func _on_combo_timer_timeout() -> void:
	var points_val = 1 * combo;
	
	if (combo > 0):
		PlayerVariables.points += points_val;
		
		var new_points_total_icon = points_icon.instantiate();
		canvas_layer.add_child(new_points_total_icon);
		new_points_total_icon.position = Vector2(160.0, 100.0);
		new_points_total_icon.text = "+" + str(points_val);
		new_points_total_icon.modulate = Color.GOLD;
