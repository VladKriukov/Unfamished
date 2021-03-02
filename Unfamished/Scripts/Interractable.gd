extends PhysicsBody

func _on_StaticBody_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
	if event.is_pressed():
		get_tree().call_group("units", "move_to", $"..")
