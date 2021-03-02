extends NinePatchRect

export var value: float
export var item_index: int

var related_item

func _on_Button_pressed():
	$"../../../../Inventory/ScrollContainer/InventoryContents"._buy(item_index, value)
	
