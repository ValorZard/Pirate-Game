extends Area2D

var bullet_speed = 200
var direction : Vector2
var bodyshotfrom

export var time_left_to_exist : float = 5
# booleans
var in_dialog : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("start_dialog", self, "start_dialog")
	SignalManager.connect("end_dialog", self, "end_dialog")

func start_dialog():
	in_dialog = true

func end_dialog():
	in_dialog = false

func _physics_process(delta):
	if !in_dialog:
		#var distance: Vector2
		position += direction * delta * bullet_speed
		time_left_to_exist -= delta
		if time_left_to_exist <= 0:
			queue_free()
	

func _on_Area2D_body_entered(body):
	if body is PlayerController:
		body.on_hit()
	if !body.is_in_group("mobs"):
		queue_free()
