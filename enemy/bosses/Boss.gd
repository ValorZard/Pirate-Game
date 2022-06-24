extends KinematicBody2D

#class_name Mobs

var player: PlayerController
export var max_health : int = 10
var health : int
export var speed : float = 100
export var default_position : Vector2

# combat variables
export (PackedScene) var cannon_ball = preload("res://bullets/BossCannonBall.tscn")
export var max_time_to_reload : float = 1.5
var time_to_reload : float

# minion spawn
var has_minion_spawned : bool = false
var minion_spawn_percent : float = 0.5 # the percentage of health left when minions spawn
export var minion = preload("res://enemy/Slime.tscn")
export var minion_amt_dropped : int = 3
export var minion_spawn_range : float = 100

# rewards
export var coin = preload("res://level/collectibles/Coin.tscn")
export var coin_amt_dropped : int = 3
export var coin_spawn_range : float = 100

# dialog related variables
export var first_dialog : String = "/first_contact"
export var rematch_dialog : String = "/rematch"
export var defeat_dialog : String = "/defeat"

var current_dialog
var in_dialog : bool = false

var first_time_speaking : bool = true

func _ready():
	add_to_group("mobs")
	$Detector.connect("body_entered", self, "_on_Detector_body_entered")
	$Detector.connect("body_exited", self, "_on_Detector_body_exited")
	
	# self default position to where we place enemy at the start of the game
	default_position = self.position
	
	time_to_reload = 0
	
	# health stuff
	health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	
	# default dialog stuff
	current_dialog = Dialogic.start(first_dialog)
	SignalManager.connect("start_dialog", self, "start_dialog")
	SignalManager.connect("end_dialog", self, "end_dialog")

func _process(delta):
	pass

func _physics_process(delta: float) -> void:
	if !in_dialog:
		var direction : Vector2
		if player != null:
			#tracking the player
			var distance = player.position - self.position
			# we normalize the vector and then times by speed to make vector math nicer
			direction = distance.normalized()
			# then, shoot bullets if reload time is up
			if time_to_reload <= 0:
				shoot()
				time_to_reload = max_time_to_reload
			time_to_reload -= delta
			#print((max_health * minion_spawn_percent <= health))
			# special case: if boss is below a certain health, it will spawn minions
			if(!has_minion_spawned and (max_health * minion_spawn_percent >= health)):
				var i = 0
				while(i < minion_amt_dropped):
					var m = minion.instance()
					m.position = self.position
					m.position.x += rand_range(-minion_spawn_range, minion_spawn_range)
					m.position.y += rand_range(-minion_spawn_range, minion_spawn_range)
					get_tree().get_root().add_child(m)
					i += 1
				has_minion_spawned = true
				print("AHHHH")
		else:
			# move back to starting position
			var distance = default_position - self.position
			# we normalize the vector and then times by speed to make vector math nicer
			direction = distance.normalized()
		move_and_slide(direction * speed)


func on_hit():
	health -= 1
	$HealthBar.value = health
	# interupt dialog since you hit them
	remove_child(current_dialog)
	#current_dialog.queue_free()
	if health <= 0:
		die()

func die():
	# right now this doesn't work since the enemy will die and delete itself before you can actually
	# delete itself before you can actually read the converstaion. Bit of an issue
	current_dialog = Dialogic.start(defeat_dialog)
	current_dialog.connect("dialogic_signal", self, "dialog_listener")
	get_tree().get_root().add_child(current_dialog)
	# we do queue free in the dialog listener to not break shit
	# reward player when die
	var i = 0
	while(i < coin_amt_dropped):
		var c = coin.instance()
		c.position = self.position
		c.position.x += rand_range(-coin_spawn_range, coin_spawn_range)
		c.position.y += rand_range(-coin_spawn_range, coin_spawn_range)
		get_tree().get_root().add_child(c)
		i += 1
	
func _on_Detector_body_entered(body):
	if body is PlayerController:
		player = body
		# handle dialog
		if first_time_speaking:
			current_dialog = Dialogic.start(first_dialog)
			first_time_speaking = false
		else:
			current_dialog = Dialogic.start(rematch_dialog)
		# add signal callbacks for dialogic signals
		current_dialog.connect("dialogic_signal", self, "dialog_listener")
		get_tree().get_root().add_child(current_dialog)

func _on_Detector_body_exited(body):
	if body is PlayerController:
		player = null
		# remove conversation since you left their area
		#remove_child(current_dialog)
		#current_dialog.queue_free()

func shoot():
	var c = cannon_ball.instance()
	var direction : Vector2 = player.position - self.position
	c.position = self.position
	c.direction = direction.normalized()
	get_tree().get_root().add_child(c)


func dialog_listener(string):
	# we send a signal from the boss to signal manager saying that dialog has started
	# if dialog has started, pause everything
	match string:
		"start_dialog":
			SignalManager.emit_signal("start_dialog")
		"end_dialog":
			SignalManager.emit_signal("end_dialog")
		"death_dialog":
			SignalManager.emit_signal("end_dialog")
			queue_free()

func start_dialog():
	in_dialog = true

func end_dialog():
	in_dialog = false
