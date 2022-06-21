extends KinematicBody2D

class_name PlayerController
export var speed = 400 #how fast the player moves inpixels/sec
# var screen_size #side of game window
export (PackedScene) var bullet
export var bullet_speed = 100
export var health : int = 10

signal add_coins

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#hide()
	#screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("shoot"):
		shoot()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $AnimatedSprite.play()
	else:
		pass
		#$AnimatedSprite.stop()
	move_and_slide(velocity)
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		pass
		#$AnimatedSprite.animation = "walk"
		#$AnimatedSprite.flip_v = false
		#$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		pass
		#$AnimatedSprite.animation = "up"
		#$AnimatedSprite.flip_v = velocity.y > 0
	if velocity.x > 0:
		pass
		#$AnimatedSprite.flip_h = true
	else:
		pass
		#$AnimatedSprite.flip_h = false
		#$AnimatedSprite.flip_h = false

func _on_Player_body_entered(Coin):
	emit_signal("add_coins")

func shoot():
	var b = bullet.instance()
	b.bodyshotfrom = self
	var direction : Vector2 = get_global_mouse_position() - self.position
	direction = direction.normalized()
	b.direction = direction
	b.position = self.position
	get_tree().get_root().add_child(b)
	
func on_hit():
	health -= 1
	if health <= 0:
		die()

func die():
	queue_free() #for now

