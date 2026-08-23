extends TextureRect

var selected_item : ShopItem;
var unlocked := false;

@export var equip_button : TextureButton;

@onready var tree := get_tree();

var crosshair;

func _ready() -> void:
	var root = tree.root;
	
	crosshair = root.find_child("Crosshair", true, false);
	
func _on_equip_button_down() -> void:
	if (unlocked):
		PlayerVariables.cross_hair_texture = selected_item.item_texture;
		PlayerVariables.save_game.cross_hair_texture = PlayerVariables.cross_hair_texture;
		PlayerVariables.write_to_save();
		
		crosshair.texture = selected_item.item_texture;
	else:
		if (!equip_button.is_moving()):
			equip_button.start_moving();
