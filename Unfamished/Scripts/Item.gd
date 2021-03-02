extends MeshInstance

export var happiness: float
export var stress: float
export var changes_destinations: bool

var button

#connect to mouse when inventory item selected and connect to all relevant remote transforms

func _connect_to_mouse():
	print("Setting item as current item")
	Game.current_item = self

func _cancel():
	Game.current_item = null
	global_transform.origin = Vector3(0, 500, 0)

func _place():
	Game.current_item = null
	if button != null:
		button._item_placed()
