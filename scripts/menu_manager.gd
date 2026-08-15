extends Node

@export var timed_game : PackedScene;
@export var hunting_game : PackedScene;
@export var burst_game : PackedScene;
@export var perfect_game : PackedScene;

@export var customize_page : PackedScene;
@export var info_page : PackedScene;

var hit_already := false;

@export var delay_timer : Timer;

var chosen_location;
var chosen_target;

@export var colored_target_outline : CompressedTexture2D;
@export var red_target_outline : CompressedTexture2D;
@export var white_target_outline : CompressedTexture2D;

@export var yellow_duck_outline : CompressedTexture2D;
@export var white_duck_outline : CompressedTexture2D;
@export var brown_duck_outline : CompressedTexture2D;

@export var colored_target_normal : CompressedTexture2D;
@export var red_target_normal : CompressedTexture2D;
@export var white_target_normal : CompressedTexture2D;

@export var yellow_duck_normal : CompressedTexture2D;
@export var white_duck_normal : CompressedTexture2D;
@export var brown_duck_normal : CompressedTexture2D;

func transition(location, target) -> void:
	if (!hit_already):
		hit_already = true;
		
		chosen_target = target;
		chosen_location = location;
		delay_timer.start();
		
func go_to_timed() -> void:
	PlayerVariables.points = 0;
	get_tree().change_scene_to_packed(timed_game);
	
func go_to_hunting() -> void:
	PlayerVariables.points = 0;
	get_tree().change_scene_to_packed(hunting_game);

func go_to_customize() -> void:
	get_tree().change_scene_to_packed(customize_page);

func go_to_info() -> void:
	get_tree().change_scene_to_packed(info_page);

func go_to_bursts() -> void:
	PlayerVariables.points = 0;
	get_tree().change_scene_to_packed(burst_game);

func go_to_perfect() -> void:
	PlayerVariables.points = 0;
	get_tree().change_scene_to_packed(perfect_game);

func _on_delay_timer_timeout() -> void:
	match chosen_location:
		chosen_target.Location.HUNTING:
			go_to_hunting();
		chosen_target.Location.TIMED:
			go_to_timed();
		chosen_target.Location.PERFECT:
			go_to_perfect();
		chosen_target.Location.BURSTS:
			go_to_bursts();
		chosen_target.Location.CUSTOMIZE:
			go_to_customize();
		chosen_target.Location.INFO:
			go_to_info();
