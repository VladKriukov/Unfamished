extends RemoteTransform

var item

func _ready():
	_deActivate()

func _on_Area_body_entered(body):
	pass
#	if body.get_parent().has_method("_place"):
#		print(str(body.get_parent().name) + " has entered " + self.name + " that has a place method")
#		item = body.get_parent()
#
#		if Game.current_transform != null:
#			Game.current_transform.remote_path = ""		
#
#		self.remote_path = item.get_path()
#		Game.current_transform = self
#		#Game.current_item = null
		

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if item != null:
		#print("Input happened")
		#item.global_transform.origin = global_transform.origin
		#Game.current_item = null
		pass
	
	if item != null and item.has_method("_place") and event.is_pressed() and event.button_index == BUTTON_LEFT:
		print("Clicked on placement")
		#item.get_parent().remove_child(item)
		self.remote_path = item.get_path()
		item.parent(self.get_path())
		item._place()
		item = null
		_deActivate()

func _on_Area_mouse_entered():
	print("Entered " + self.name)
	
	item = Game.current_item
	
	if Game.current_transform != null:
		Game.current_transform.remote_path = ""
		
	self.remote_path = item.get_path()
	Game.current_transform = self
	
	if item != null:
		#print("Mouse entered " + self.name)
		item.global_transform.origin = global_transform.origin
		#Game.current_item = null

func _on_Area_mouse_exited():
	print("Exited "+ self.name)
	if item != null:
		print("Mouse exited successfully")
		self.remote_path = ""
		Game.current_item = item
		item = null

func _activate():
	$Area/CollisionShape.disabled = false
	#print("Activated")
	pass

func _deActivate():
	#print("Deactivate")
	$Area/CollisionShape.disabled = true
	item = null
	pass
