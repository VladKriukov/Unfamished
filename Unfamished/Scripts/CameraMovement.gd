extends Spatial

export var movement_speed: float

export var mouse_move_sensitivity: float
export (float, 0.1, 1) var mouse_rotate_sensitivity
export var mouse_scroll_sensitivity: float

var mouse_scroll_value: float

var camera_change
var camera_change_y_rotation: float
var camera_basis

var direction = Vector3.ZERO
var velocity = Vector3.ZERO

export var camera_angle = 0

onready var camera_pivot = $CameraPivot
onready var camera = $CameraPivot/Camera


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_change = event.relative
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			mouse_scroll_value += mouse_scroll_sensitivity
		elif event.button_index == BUTTON_WHEEL_DOWN:
			mouse_scroll_value -= mouse_scroll_sensitivity

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	#if Input.get_action_strength("middle_click") > 0 and camera_change.length() > 0:
		#_pan_camera(delta)
	if Input.get_action_strength("right_click") > 0:# and camera_change.length() > 0:
		_orbit_camera(delta)
	if camera_change_y_rotation != 0:
		_orbit_camera(delta)
	if mouse_scroll_value != 0:
		camera_pivot.spring_length -= mouse_scroll_value * delta * 10
		camera_pivot.spring_length = clamp(camera_pivot.spring_length, 5, 20)
	_move()
	_smoothen(delta)

func _physics_process(delta: float) -> void:
	camera_basis = camera.get_global_transform().basis
	
	if direction != Vector3.ZERO and Input.get_action_strength("middle_click") == 0:
		velocity.x += direction.x * delta * (camera_pivot.spring_length / 10)
		velocity.z += direction.z * delta * (camera_pivot.spring_length / 10)
	
	velocity.x = clamp(velocity.x, -0.15, 0.15)
	velocity.z = clamp(velocity.z, -0.15, 0.15)
	
	transform.origin += velocity

func _pan_camera(delta):
	direction = Vector3.ZERO
	
	#direction.x += camera_change.x * mouse_move_sensitivity
	#direction.z += camera_change.y * mouse_move_sensitivity
	
	var _direction = Vector3.ZERO
	
	_direction.x = camera_change.x
	_direction.z = camera_change.y
	
	direction += camera_basis.x * _direction * mouse_move_sensitivity
	
	direction.normalized()
	
	velocity.x = direction.x * delta * (camera_pivot.spring_length / 10)
	velocity.z = direction.z * delta * (camera_pivot.spring_length / 10)

func _move():
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction -= camera_basis.x * Input.get_action_strength("move_left")
	if Input.is_action_pressed("move_right"):
		direction += camera_basis.x * Input.get_action_strength("move_right")
	if Input.is_action_pressed("move_forward"):
		direction -= camera_basis.z * Input.get_action_strength("move_forward")
	if Input.is_action_pressed("move_backward"):
		direction += camera_basis.z * Input.get_action_strength("move_backward")
	
	direction.y = 0
	direction = direction.normalized() * movement_speed

func _orbit_camera(delta):
	if Input.get_action_strength("right_click") > 0:
		camera_change_y_rotation += clamp(-camera_change.x * mouse_rotate_sensitivity * 0.1, -5, 5)
	camera_change_y_rotation = clamp(camera_change_y_rotation, -5, 5)
	rotate_y(deg2rad(camera_change_y_rotation))
	var change = -camera_change.y * mouse_rotate_sensitivity * 0.3
	if change + camera_angle < -20 and change + camera_angle > -60 and Input.get_action_strength("right_click") > 0:
		camera_pivot.rotate_x(deg2rad(change))
		camera_angle += change

func _smoothen(delta):
	if camera_change != null:
		mouse_scroll_value = _smoothen_float(mouse_scroll_value, delta * 0.5, 0.1)
		camera_change_y_rotation = _smoothen_float(camera_change_y_rotation, delta * 5, 0.5)
		
		camera_change = _smoothen_vector2(camera_change, delta * 10)
		velocity = _smoothen_vector3(velocity, delta * 10)

func _smoothen_float(item: float, delta, threshold: float) -> float:
	if item > threshold:
		item -= delta * 5
	elif item < -threshold:
		item += delta * 5
	else:
		item = 0
	return item

func _smoothen_vector3(item: Vector3, delta) -> Vector3:
	if item.x > 0.01:
		item.x -= delta * 0.1
	elif item.x < -0.01:
		item.x += delta * 0.1
	else:
		item.x = 0
	if item.z > 0.01:
		item.z -= delta * 0.1
	elif item.z < -0.01:
		item.z += delta * 0.1
	else:
		item.z = 0
	return item

func _smoothen_vector2(item: Vector2, delta) -> Vector2:
	if item.x > 0.01:
		item.x -= delta * 0.1
	elif item.x < -0.01:
		item.x += delta * 0.1
	else:
		item.x = 0
	if item.y > 0.01:
		item.y -= delta * 0.1
	elif item.y < -0.01:
		item.y += delta * 0.1
	else:
		item.y = 0
	return item
