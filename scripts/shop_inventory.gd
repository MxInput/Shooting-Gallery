class_name ShopInventory 
extends Resource

var inventory : Array;

func _init(_inventory := []) -> void:
	inventory = [
		ShopItem.new("000", "Unlocked", ImageTexture.create_from_image(Image.load_from_file("res://images/crosshairs/crosshair_outline_small.png"))),
		ShopItem.new("001", "Hit a Duck.", ImageTexture.create_from_image(Image.load_from_file("res://images/crosshairs/crosshair002.png"))),
		ShopItem.new("002", "Hit a Target.", ImageTexture.create_from_image(Image.load_from_file("res://images/crosshairs/crosshair003.png"))),
		ShopItem.new("003", "Hit a combination of 15 targets and ducks.", ImageTexture.create_from_image(Image.load_from_file("res://images/crosshairs/crosshair007.png"))),
		ShopItem.new("004", "Last 4+ minutes in Hunting.", ImageTexture.create_from_image(Image.load_from_file("res://images/crosshairs/crosshair025.png")))
		ShopItem.new("005", "Get 100+ in Timed.", ImageTexture.create_from_image(Image.load_from_file("res://images/crosshairs/crosshair025.png")))
		ShopItem.new("006", "Get a perfect in Perfect.", ImageTexture.create_from_image(Image.load_from_file("res://images/crosshairs/crosshair025.png")))
		ShopItem.new("007", "Last 4+ minutes in Hunting.", ImageTexture.create_from_image(Image.load_from_file("res://images/crosshairs/crosshair025.png")))
		ShopItem.new("008", "Last 4+ minutes in Hunting.", ImageTexture.create_from_image(Image.load_from_file("res://images/crosshairs/crosshair025.png")))
	];
