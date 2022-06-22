extends KinematicBody2D

class_name PlayerController
export var speed = 400 #how fast the player moves inpixels/sec
# var screen_size #side of game window
# combat variables
export (PackedScene) var bullet
export var bullet_speed = 100
export var max_time_to_reload : float = 0.5
var time_to_reload : float = 0

export var max_health : int = 10
export var health : int = 10

# booleans
var in_dialog : bool = false

signal add_coins

# Called when the node enters the scene tree for the first time.
func _ready():
	# health bar stuff
	$Camera2D/PlayerUI/UIContainer/HealthBar.max_value = max_health
	health = max_health
	$Camera2D/PlayerUI/UIContainer/HealthBar.value = health
	
	SignalManager.connect("start_dialog", self, "start_dialog")
	SignalManager.connect("end_dialog", self, "end_dialog")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta : float):
	if !in_dialog:
		var velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		
		# shootin code
		time_to_reload -= delta
		# be able to shoot whenever you want once you've finished reloading
		if time_to_reload <= 0:
			if Input.is_action_just_pressed("shoot"):
				shoot()
				time_to_reload = max_time_to_reload

		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		else:
			pass
			
		move_and_slide(velocity)

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
	$Camera2D/PlayerUI/UIContainer/HealthBar.value = health
	if health <= 0:
		die()

func die():
	queue_free() #for now

func start_dialog():
	in_dialog = true

func end_dialog():
	in_dialog = false
