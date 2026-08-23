class_name ShopInventory 
extends Resource

var inventory : Array;

func _init(_inventory := []) -> void:
	inventory = [
		ShopItem.new("000", "Default", ImageTexture.create_from_image(load("res://images/crosshair_img/crosshair_outline_small.png"))),
		ShopItem.new("001", "Hit a Duck.", ImageTexture.create_from_image(load("res://images/crosshair_img/crosshair002.png"))),
		ShopItem.new("002", "Hit a Target.", ImageTexture.create_from_image(load("res://images/crosshair_img/crosshair003.png"))),
		ShopItem.new("003", "Hit a combination of 15 targets and ducks.", ImageTexture.create_from_image(load("res://images/crosshair_img/crosshair007.png"))),
		ShopItem.new("004", "Last 4+ minutes in Hunting.", ImageTexture.create_from_image(load("res://images/crosshair_img/crosshair025.png"))),
		ShopItem.new("005", "Get 100+ in Timed.", ImageTexture.create_from_image(load("res://images/crosshair_img/crosshair004.png"))),
		ShopItem.new("006", "Get a perfect in Perfect.", ImageTexture.create_from_image(load("res://images/crosshair_img/crosshair022.png"))),
		ShopItem.new("007", "Run out of ammo 6+ times in Burst.", ImageTexture.create_from_image(load("res://images/crosshair_img/crosshair192.png"))),
		ShopItem.new("008", "Earn your first crosshair.", ImageTexture.create_from_image(load("res://images/crosshair_img/crosshair190.png")))
	];
