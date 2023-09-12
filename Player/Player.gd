extends CharacterBody2D


var speed=5
var max_speed=400
var rotate_speed=0.08



func _physics_process(delta):
	if Input.is_action_pressed("Left"):
		rotation = rotation - rotate_speed
	if Input.is_action_pressed("Right"):
		rotation = rotation + rotate_speed
	if Input.is_action_pressed("Forward"):
		velocity =velocity + Vector2(0,-speed).rotated(rotation)
	print(velocity)
	
	position.x=wrapf(position.x, 0, 1152)
	position.y=wrapf(position.y, 0, 648)
	velocity=velocity.normalized() * clamp(velocity.length(), 0, max_speed)
	
	print(velocity.length())
	
	move_and_slide()
