extends StaticBody

func _ready():
	#$"..".visible = false
	pass

func _on_Destination_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
	if event.is_pressed():
		get_tree().call_group("units", "move_to", $"..")
		print("clicked on destination")
