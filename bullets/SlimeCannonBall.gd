extends Area2D

var bullet_speed = 200
var direction : Vector2
var bodyshotfrom

export var time_left_to_exist : float = 5

func _physics_process(delta):
	#var distance: Vector2
	position += direction * delta * bullet_speed
	time_left_to_exist -= delta
	if time_left_to_exist <= 0:
		queue_free()
	pass

func _on_Area2D_body_entered(body):
	if body is PlayerController:
		body.on_hit()
	if !body.is_in_group("mobs"):
		queue_free()
