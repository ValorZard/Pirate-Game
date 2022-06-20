extends Area2D

var speed = 750
var direction
var bodyshotfrom

func _physics_process(delta):
	var distance: Vector2
	#move_and_slide(distance)
	pass

func _on_PlayerBullet_body_entered(body):
	if body != bodyshotfrom:
		body.queue_free()
