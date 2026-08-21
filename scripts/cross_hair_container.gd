extends TextureRect

var selected_item : ShopItem;
var unlocked := false;

func _on_equip_button_down() -> void:
	PlayerVariables.cross_hair_texture = selected_item.item_texture;
