extends Node

@export var color_picker : ColorPicker;

@onready var menu = "res://nodes/menu.tscn";
@onready var tree = get_tree();

@export var inventory := ShopInventory.new();
@export var shop_item_template : PackedScene;

@export var h_box : HBoxContainer;

@export var crosshair : TextureRect;

func _ready() -> void:
	color_picker.color = PlayerVariables.target_color;

	var inventory_arr := inventory.inventory;
	
	var player_quest_status := PlayerVariables.complete_status_quests;
	
	var count := 0;
	for shop_item in inventory_arr:
		var new_item_container = shop_item_template.instantiate();
		h_box.add_child(new_item_container);
		new_item_container.find_child("CrosshairImage").texture = shop_item.item_texture;
		new_item_container.find_child("Description").text = shop_item.unlock_description;
		
		new_item_container.selected_item = shop_item;

		if (player_quest_status[count]):
			new_item_container.unlocked = true;
			
		new_item_container.name = shop_item.item_name;
		
		count += 1;
			
func _on_color_picker_color_changed(color: Color) -> void:
	PlayerVariables.target_color = color;
	PlayerVariables.save_game.target_color = PlayerVariables.target_color;
	PlayerVariables.write_to_save();
	
	crosshair.modulate = color;

func _on_return_button_down() -> void:
	tree.change_scene_to_file(menu);
