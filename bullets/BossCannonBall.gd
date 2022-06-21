extends Area2D

var cannon_ball_speed = 5
var direction : Vector2
var bodyshotfrom

export var time_left_to_exist : float = 5

func _ready():
	self.connect("body_entered", self, "_on_CannonBall_body_entered")

func _physics_process(delta):
	#var distance: Vector2
	position += direction * delta * cannon_ball_speed
	time_left_to_exist -= delta
	if time_left_to_exist <= 0:
		queue_free()
	pass

func _on_CannonBall_body_entered(body):
	# on hit for the player exists on snowys code, but not on mine
	if body is PlayerController:
		#body.on_hit()
		queue_free()
