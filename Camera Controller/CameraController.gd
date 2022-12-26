extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 80
var sprintSpeed = speed * 4
export var friction = 40.0
var margin = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var _sprites := {Vector2.RIGHT: 1, Vector2.LEFT: 2, Vector2.UP: 3, Vector2.DOWN: 4}
var _velocity := Vector2.ZERO
func _physics_process(_delta):
	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	position = Vector2(clamp(position.x, -margin, (Grid.size.x * Grid.resolution.x) + margin), clamp(position.y, -margin, (Grid.size.y * Grid.resolution.y) + margin))
	if direction.length() > 1.0:
		direction = direction.normalized()
	# Using the follow steering behavior.
	if(Input.get_action_strength("sprint") > 0):
		var target_velocity = direction * sprintSpeed
		_velocity += (target_velocity - _velocity) * friction
		_velocity = move_and_slide(_velocity)
	else:
	
		var target_velocity = direction * speed
		_velocity += (target_velocity - _velocity) * friction
		_velocity = move_and_slide(_velocity)
