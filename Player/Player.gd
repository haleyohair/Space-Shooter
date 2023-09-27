extends CharacterBody2D


var speed=5
var max_speed=400
var rotate_speed=0.08
var nose=Vector2(0,-60)
var health=10
var Bullet=load("res://Player/bullet.tscn")
var Effects=null
var Explosion=load("res://Effects/explosion.tscn")

var shields=0
var shields_regen=0.1
var shield_max=50.0
var shield_textures= [
	preload("res://Assets/fullshield1.png"),
	preload("res://Assets/halfshield1.png"),
	preload("res://Assets/lowshield1.png")
]

func get_input():
	var to_return = Vector2.ZERO
	$Exhaust.hide()
	if Input.is_action_pressed("Forward"):
		to_return += Vector2(0,-1)
		$Exhaust.show()
	if Input.is_action_pressed("Left"):
		rotation -= rotate_speed
	if Input.is_action_pressed("Right"):
		rotation += rotate_speed
	return to_return.rotated(rotation) 


func _physics_process(_delta):
	velocity+=get_input()*speed
	velocity=velocity.normalized()*clamp(velocity.length(), 0, max_speed)
	
	position.x=wrapf(position.x, 0, Global.VP.x)
	position.y=wrapf(position.y, 0, Global.VP.y)
	velocity=velocity.normalized() * clamp(velocity.length(), 0, max_speed)
	
	print(velocity.length())
	
	move_and_slide()
	
	shields= clamp(shields + shields_regen,-100,shield_max)
	if shields>=shield_max:
		$Shield.hide()
	elif shields>=shield_max*0.75:
		$Shield.show()
		$Shield/Sprite.texture= shield_textures[0]
	elif shields>=shield_max*0.4:
		$Shield.show()
		$Shield/Sprite.texture= shield_textures[1]
	elif shields>0:
		$Shield.show()
		$Shield/Sprite.texture= shield_textures[2]
	else:
		$Shield.hide()
	
	if Input.is_action_just_pressed("Shoot"):
		var bullet=Bullet.instantiate()
		bullet.position=position+nose.rotated(rotation)
		bullet.rotation=rotation
		@warning_ignore("shadowed_variable")
		var Effects=get_node_or_null("/root/Game/Effects")
		if Effects!=null:
			Effects.add_child(bullet)
			
func damage(d):
	health=health-d
	if health<=0:
		Effects=get_node_or_null("/root/Game/Effects")
		if Effects!=null:
			var explosion=Explosion.instantiate()
			Effects.add_child(explosion)
			explosion.global_position=global_position
			hide()
			await explosion.animation_finished
		Global.update_lives(-1)
		queue_free()


func _on_area_2d_body_entered(body):
	if body.name!="Player":
		damage(100)


func _on_shield_area_entered(area):
	if "damage" in area and not area.is_in_group("friendly") and shields>=0:
		shields-= area.damage
		area.queue_free()
		


func _on_shield_body_entered(body):
	if body!=self and not body.is_in_group("friendly") and body.has_method("damage") and shields>=0:
		shields-=100
		body.damage(100)

		
