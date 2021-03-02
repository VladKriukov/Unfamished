extends AnimationPlayer

onready var animationPlayer: AnimationPlayer = get_node(".")

func _on_ShopButton_toggled(button_pressed):
	if button_pressed == true:
		animationPlayer.play("On")
	else:
		animationPlayer.play_backwards("On")
