extends StaticBody

func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if event.is_pressed():
		print(click_position)
