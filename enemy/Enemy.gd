extends KinematicBody2D

class_name Enemy

var player: PlayerController
export var max_health : int = 10
var health : int
export var cannonball = preload("res://bullets/SlimeCannonBall.tscn")
export var coin = preload("res://level/collectibles/Coin.tscn")
export var max_time_to_shoot : float = 1.5
var time_to_shoot : float
export var default_position : Vector2
export var speed : float = 100.0

var in_dialog : bool = false

func _setup_enemy():
	add_to_group("mobs")
	
	time_to_shoot = max_time_to_shoot
	
	# self default position to where we place enemy at the start of the game
	default_position = self.position
	
	# health stuff
	health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	
	# Setup signals
	SignalManager.connect("start_dialog", self, "start_dialog")
	SignalManager.connect("end_dialog", self, "end_dialog")
	
	$Detector.connect("body_entered", self, "_on_Detector_body_entered")
	$Detector.connect("body_exited", self, "_on_Detector_body_exited")

func _ready():
	_setup_enemy()

func _physics_process(delta: float) -> void:
	if !in_dialog:
		if player != null:
			time_to_shoot -= delta
			var distance: Vector2
			distance = player.position - self.position
			var direction = distance.normalized()
			move_and_slide(direction * speed) #tracking, basically - snowy
			if time_to_shoot <= 0:
				fire()
				time_to_shoot = max_time_to_shoot
		else:
			var distance = default_position - self.position
			var direction = distance.normalized()
			move_and_slide(direction * speed)

func on_hit():
	health -= 1
	$HealthBar.value = health
	if health <= 0:
		die()

func die():
	# reward player when die
	var c = coin.instance()
	c.position = self.position
	get_tree().get_root().add_child(c)
	queue_free()

func _on_Detector_body_entered(body):
	if body is PlayerController:
		player = body
		#fire()
	pass

func _on_Detector_body_exited(body):
	if body is PlayerController:
		player = null
	pass 

func fire():
	var c = cannonball.instance()
	var direction : Vector2 = player.position - self.position
	c.position = self.position
	c.direction = direction.normalized()
	get_tree().get_root().add_child(c)

func start_dialog():
	in_dialog = true

func end_dialog():
	in_dialog = false
