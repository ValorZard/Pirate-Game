extends KinematicBody2D

class_name PlayerController
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

#movement stuff
var friction = 0.1
var acceleration = 0.5
var velocity = Vector2.ZERO
var current_rotation : float = 0
export var speed : float = 400 #how fast the player moves inpixels/sec
var rotation_speed : float = 1

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
		var input_dir = 0
		#move
		if Input.is_action_pressed("move_down"):
			input_dir += 1
		if Input.is_action_pressed("move_up"):
			input_dir -= 1
		#rotate
		if Input.is_action_pressed("move_right"):
			current_rotation += rotation_speed
		if Input.is_action_pressed("move_left"):
			current_rotation -= rotation_speed
		#friction
		if input_dir != 0:
			velocity.y = lerp(velocity.y, input_dir * speed, acceleration)
		else:	
			velocity.y = lerp(velocity.y, 0, friction)
		
		
		#print(velocity)
		# shootin code
		time_to_reload -= delta
		# be able to shoot whenever you want once you've finished reloading
		if time_to_reload <= 0:
			if Input.is_action_just_pressed("shoot"):
				shoot()
				time_to_reload = max_time_to_reload
		
		
		move_and_slide(velocity.rotated(deg2rad(current_rotation)))
		
		$Icon.rotation_degrees = current_rotation

func _on_Player_body_entered(Coin):
	emit_signal("add_coins")

func shoot():
	var b = bullet.instance()
	b.bodyshotfrom = self
	var direction : Vector2 = get_global_mouse_position() - self.position
	direction = direction.normalized()
	b.direction = direction
	b.position = self.position
	b.bullet_speed = bullet_speed
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
