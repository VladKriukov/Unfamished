extends Camera

const ray_length = 1000
var mouse_pos

onready var mesh = $MeshInstance

func _process(delta):
	
#	if Game.current_item != null:
#		#print("Something in current item")
#		mouse_pos = get_viewport().get_mouse_position()
#		var camera = get_node(self.get_path())
#		var ray_origin = camera.project_ray_origin(mouse_pos)
#		var ray_direction = camera.project_ray_normal(mouse_pos)
#		var from = ray_origin
#		var to = ray_origin + ray_direction * 1000.0
#		var space_state = get_world().get_direct_space_state()
#		var hit = space_state.intersect_ray(from, to, [self], 0b1)
#		if hit.size() != 0:
#			Game.current_item.global_transform.origin = hit.position
#			mesh.global_transform.origin = hit.position
#			#Game.current_item.global_transform.origin.y = 0
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		pass
		#print(get_object_under_mouse())
		
		
		#var from = project_ray_origin(event.position)
		#var to = from + project_ray_normal(event.position) * ray_length
		#var space_state = get_world().direct_space_state
		#var result = space_state.intersect_ray(from, to, [], 1)
		
		#if result != null:
			#print("hit something")
			#print(result)
			#if result.collider != null:#.has_method("assign_movable"):
			#	result.collider.assign_movable()
			#elif result.collider.has_method("interract"):
			#	result.collider.interract()
			#else:
			#	get_tree().call_group("units", "move_to", result.position)

# cast a ray from camera at mouse position, and get the object colliding with the ray
func get_object_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = project_ray_origin(mouse_pos)
	var ray_to = ray_from + project_ray_normal(mouse_pos) * ray_length
	var space_state = get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection
