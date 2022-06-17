extends KinematicBody2D

export var speed = 400 #how fast the player moves inpixels/sec
# var screen_size #side of game window

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

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $AnimatedSprite.play()
	else:
		pass
		#$AnimatedSprite.stop()
	position += velocity * delta
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
