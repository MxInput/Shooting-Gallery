extends Area2D

@onready var aim_controller = get_parent().get_parent().get_parent().find_child("AimController");

func _on_mouse_entered() -> void:
	aim_controller.blocked = true;

func _on_mouse_exited() -> void:
	aim_controller.blocked = false;
