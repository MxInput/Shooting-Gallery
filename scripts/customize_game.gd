extends Node

@export var color_picker : ColorPicker;

@onready var menu = "res://nodes/menu.tscn";
@onready var tree = get_tree();

@export var inventory := ShopInventory.new();
@export var shop_item_template : PackedScene;

@export var h_box : HBoxContainer;

func _ready() -> void:
	color_picker.color = PlayerVariables.target_color;

	for shop_item in inventory.inventory:
		var new_item_container = shop_item_template.instantiate();
		h_box.add_child(new_item_container);
		new_item_container.find_child("CrosshairImage").texture = shop_item.item_texture;
		new_item_container.find_child("Description").text = shop_item.unlock_description;
		
		new_item_container.selected_item = shop_item;
		
func _on_color_picker_color_changed(color: Color) -> void:
	PlayerVariables.target_color = color;

func _on_return_button_down() -> void:
	tree.change_scene_to_file(menu);
