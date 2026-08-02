class_name ShopItem
extends Resource

enum Item_Type {
	CROSS_HAIR
}

var item_name : String;
var unlock_description : String;
var item_texture : Texture2D;
var offset : Vector2;
var type : Item_Type;

func _init(_item_name := "", _unlock_description := "", _item_texture := Texture2D.new(), _offset := Vector2(), _type := Item_Type.CROSS_HAIR) -> void:
	item_name = _item_name;
	unlock_description = _unlock_description;
	item_texture = _item_texture;
	offset = _offset;
	type = _type;
