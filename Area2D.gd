extends Area2D

var bullet_speed = 100
var direction
var bodyshotfrom

func _physics_process(delta):
	var distance: Vector2
	#move_and_slide(distance)
	pass

func _on_PlayerBullet_body_entered(body):
	if body.is_in_group("Mobs"):
		queue_free()
