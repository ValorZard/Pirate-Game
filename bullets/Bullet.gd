extends Area2D

var bullet_speed = 100
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

func _on_PlayerBullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.on_hit()
		queue_free()
