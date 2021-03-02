extends KinematicBody

var at_turning_curve:Curve = preload("res://Data/ai_turn.tres")

var h
var path = []
var path_ind = 0
const move_speed = 5
onready var nav = get_parent()

var stress: float

onready var timer = $Timer

var target_pos

onready var tween = get_node("Tween")
onready var aIindicator = get_node("AIIndicator")


func assign_movable():
	add_to_group("units")
	print("added to units group")

func unassign_movable():
	remove_from_group("units")
	print("removed from units group")

func _physics_process(delta: float) -> void:
	if target_pos:
		
		aIindicator.look_at((target_pos),Vector3.UP)
		h = aIindicator.rotation_degrees.y
		h = (h / 180)
		var h2 = at_turning_curve.interpolate_baked( abs(h))
		
		if h < 0:
			h2 = -h2
		h2 = clamp(h2,-1,1)
		h2 = -h2
		
		rotate_y(h2/2)
		#(indicator.global_transform.origin - target.global_transform.origin).length()
		if (global_transform.origin - target_pos).length() < 0.5:
			print("reached destination")
			target_pos = null
		
		pass
	
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)# path[path_ind] or target_pos
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * move_speed, Vector3.UP)

func move_to(_target_pos):
	print("received target")
	print(_target_pos)
	target_pos = _target_pos.transform.origin
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0
	unassign_movable()

func _on_Area_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
	if event.is_pressed():
		print("Player was clicked on")
		if is_in_group("units") == false:
			assign_movable()
		print(is_in_group("units"))

func _on_Timer_timeout():
	
	pass
