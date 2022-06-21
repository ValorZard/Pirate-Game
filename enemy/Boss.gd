extends KinematicBody2D

#class_name Mobs

var player: PlayerController
export var health : int = 10
export var speed : float = 100
export var default_position : Vector2

# combat variables
export (PackedScene) var cannon_ball = preload("res://bullets/BossCannonBall.tscn")
var max_time_to_reload : float = 0.5
var time_to_reload : float

# dialog related variables
export var first_dialog : String = "/first_contact"
export var rematch_dialog : String = "/rematch"
export var defeat_dialog : String = "/defeat"

var current_dialog

var first_time_speaking : bool = true

func _ready():
	add_to_group("mobs")
	$Detector.connect("body_entered", self, "_on_Detector_body_entered")
	$Detector.connect("body_exited", self, "_on_Detector_body_exited")
	
	# self default position to where we place enemy at the start of the game
	default_position = self.position
	
	time_to_reload = 0

func _process(delta):
	pass

func _physics_process(delta: float) -> void:
	var direction : Vector2
	if player != null:
		#tracking the player
		var distance = player.position - self.position
		# we normalize the vector and then times by speed to make vector math nicer
		direction = distance.normalized()
		# then, shoot bullets if reload time is up
		if time_to_reload <= 0:
			shoot(distance)
			time_to_reload = max_time_to_reload
		time_to_reload -= delta
	else:
		# move back to starting position
		var distance = default_position - self.position
		# we normalize the vector and then times by speed to make vector math nicer
		direction = distance.normalized()
	move_and_slide(direction * speed)


func on_hit():
	health -= 1
	# interupt dialog since you hit them
	remove_child(current_dialog)
	if health <= 0:
		die()

func die():
	# right now this doesn't work since the enemy will die and delete itself before you can actually
	# delete itself before you can actually read the converstaion. Bit of an issue
	current_dialog = Dialogic.start(defeat_dialog)
	add_child(current_dialog)
	queue_free()

func _on_Detector_body_entered(body):
	if body is PlayerController:
		player = body
		if first_time_speaking:
			current_dialog = Dialogic.start(first_dialog)
			first_time_speaking = false
		else:
			current_dialog = Dialogic.start(rematch_dialog)
		add_child(current_dialog)

func _on_Detector_body_exited(body):
	if body is PlayerController:
		player = null
		# remove conversation since you left their area
		remove_child(current_dialog)

func shoot(direction : Vector2):
	var c = cannon_ball.instance()
	c.bodyshotfrom = self
	c.direction = direction
	c.position = self.position
	get_tree().get_root().add_child(c)