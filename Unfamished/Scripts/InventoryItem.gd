extends NinePatchRect

export var game_item_index: int

onready var spawner = $"../../../../../GameItems"

func _on_Button_pressed():
	print("Inventory item clicked")
	print(game_item_index)
	spawner.get_child(game_item_index).get_child(0)._connect_to_mouse()
	spawner.get_child(game_item_index).get_child(0).button = self
	for item in get_parent().get_children():
		item.get_node("Button").disabled = true
	get_tree().call_group("places", "_activate")

func _placement_cancelled():
	spawner.get_child(game_item_index).get_child(0)._cancel()
	for item in get_parent().get_children():
		item.get_node("Button").disabled = false
	print("Item canceled")
	get_tree().call_group("places", "_deActivate")

func _item_placed():
	print("Item placed")
	for item in get_parent().get_children():
		item.get_node("Button").disabled = false
	get_tree().call_group("places", "_deActivate")
	queue_free()
