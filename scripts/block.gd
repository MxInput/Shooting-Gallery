extends Area2D

var aim_controller;

func _ready() -> void:
	aim_controller = get_parent().get_parent().get_parent().find_child("AimController");
	
	if (aim_controller == null):
		aim_controller = get_parent().get_parent().get_parent().get_parent().find_child("CrosshairHandler");

func _on_mouse_entered() -> void:
	aim_controller.blocked = true;

func _on_mouse_exited() -> void:
	aim_controller.blocked = false;
