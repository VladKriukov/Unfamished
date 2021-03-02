extends VehicleBody

enum ControlledBy { PLAYER_1, PLAYER_2, PLAYER_3, PLAYER_4, AI, NETWORK }
export(ControlledBy) var controlledBy

var speed:float
var drift:float

export var behaviors = []

export var angular_damp_value:float = 60

#AI
var at_turning_curve:Curve = preload("res://data/ai/ai_turn.tres")
var at_throttle_curve:Curve = preload("res://data/ai/ai_throttle.tres")
onready var indicator = $"AI/Indicator"
onready var rayLeft = $"AI/RayLeft"
onready var rayRight = $"AI/RayRight"
var leftObstacleDistance:float
var rightObstacleDistance:float

var target:Spatial
var waypointGroup:Spatial = null
var waypointId:int = -1
var waypointCount:int =-1
var distance:float = 99999
var h:float

onready var fl = $FL
onready var fr = $FR
onready var rl = $RL
onready var rr = $RR

var steer_force:float = -0.7
export var throttle_force:float = 2400
export var brake_force:float = 2400
export var handbrake_force:float = 2400

export var steer:float
export var steer_sensitivity:float = 20
export var throttle:float
export var brakes:float
export var hand_brake:bool

var _steer:float
var _throttle:float
var _brakes:float
var _hand_brake:bool

var x_velocity:float = 0.0
var z_velocity:float = 0.0

func _physics_process(delta):
	speed = transform.basis.xform_inv(linear_velocity).z
	angular_damp = abs(speed+0.4) / angular_damp_value
	drift = abs(transform.basis.xform_inv(linear_velocity).x)
	physics_fix()
	
	
	
	PlayerInput(controlledBy,delta)
	_steer = lerp(_steer,steer,steer_sensitivity*delta)
	steering = _steer * steer_force
	if brakes > 0.1:
		if speed > 10:
			fl.brake = brake_force
			fr.brake = brake_force
			fl.engine_force = 0
			fr.engine_force = 0
		else:
			engine_force = -brakes * brake_force * delta # + abs(delta * x_velocity * 500)
			#add_force((get_global_transform().basis.z.normalized() * delta * abs(x_velocity * 1000)), Vector3(0,0,0))
	else:
		fl.brake = 0
		fr.brake = 0

		if hand_brake:
			rl.brake = handbrake_force
			rr.brake = handbrake_force
			rl.engine_force = 0
			rr.engine_force = 0
		else:
			rl.brake = 0
			rr.brake = 0

		engine_force = throttle * throttle_force * delta # + abs(delta * x_velocity * 500)
		#add_force((get_global_transform().basis.z.normalized() * delta * abs(x_velocity * 1000)), Vector3(0,0,0))
	

func physics_fix():
	z_velocity = transform.basis.xform_inv(linear_velocity).z
	x_velocity = transform.basis.xform_inv(linear_velocity).x

func PlayerInput(id:int, delta) -> void:
	match id:
		4:
			if(Game.waypoints!=null):
				if(waypointGroup==null):
					_find_new_waypoint_group()
				indicator.look_at(target.global_transform.origin,Vector3.UP)
				h = indicator.rotation_degrees.y
				h = (h / 180 )
				var h2 = at_turning_curve.interpolate_baked( abs(h))
				if h < 0:
					h2 = -h2
				distance = (indicator.global_transform.origin - target.global_transform.origin).length()
				if(distance<10):
					_next_waypoint()
				if distance > 30:
					throttle = at_throttle_curve.interpolate_baked( abs(h))
				else:
					throttle = distance / 30
				if distance < 10:
					throttle = 0.2
				leftObstacleDistance = 30
				rightObstacleDistance = 30
				
				rayLeft.cast_to.z = speed/2 + 1
				rayRight.cast_to.z = speed/2 + 1
				
				if(rayLeft.is_colliding()):
					leftObstacleDistance = (rayLeft.global_transform.origin - rayLeft.get_collision_point()).length()
				if(rayRight.is_colliding()):
					rightObstacleDistance = (rayRight.global_transform.origin - rayRight.get_collision_point()).length()
				
				if(leftObstacleDistance > rightObstacleDistance):
					h2 = -1
				if(leftObstacleDistance < rightObstacleDistance):
					h2 = 1
					
				throttle = 1
				h2 = clamp(h2,-1,1)
				steer = h2


func _find_new_waypoint_group():
	waypointGroup = Game.waypoints[randi()%Game.waypoints.size()]
	waypointId = 0
	waypointCount = waypointGroup.get_child_count()
	target = waypointGroup.get_child(waypointId)

func _next_waypoint():
	waypointId = waypointId + 1
	if(waypointId>=waypointCount):
		_find_new_waypoint_group()
	else:
		target = waypointGroup.get_child(waypointId)
	pass
