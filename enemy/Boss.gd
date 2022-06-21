extends KinematicBody2D

#class_name Mobs

var player: PlayerController
export var health : int = 10
export var speed : float = 100
export var default_position : Vector2


func _ready():
	add_to_group("mobs")
	$Detector.connect("body_entered", self, "_on_Detector_body_entered")
	$Detector.connect("body_exited", self, "_on_Detector_body_exited")
	
	# self default position to where we place enemy at the start of the game
	default_position = self.position

func _process(delta):
	pass

func _physics_process(delta: float) -> void:
	var distance: Vector2
	if player != null:
		#tracking the player
		distance = player.position - self.position
		# we normalize the vector and then times by speed to make vector math nicer
	else:
		# move back to starting position
		distance = default_position - self.position
	move_and_slide(distance.normalized() * speed)


func on_hit():
	health -= 1
	if health <= 0:
		die()

func die():
	queue_free()

func _on_Detector_body_entered(body):
	if body is PlayerController:
		player = body

func _on_Detector_body_exited(body):
	if body is PlayerController:
		player = null
