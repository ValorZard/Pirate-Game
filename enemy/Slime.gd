extends KinematicBody2D

#class_name Mobs

var player: PlayerController
export var health : int = 10
export var cannonball = preload("res://SlimeCannonBall.tscn")
var max_time_to_shoot = 1.5
var time_to_shoot
export var default_position : Vector2
var speed = 100.0

func _ready():
	add_to_group("mobs")
	time_to_shoot = max_time_to_shoot
	default_position = self.position

func _process(delta):
	pass

#func generate_raycasts() -> void:
	#var ray_count := angle_cone_of_vision / angle_between_rays
	
	#for index in ray_count:
		#var ray = RayCast2D.new()
		#var angle : float = angle_between_rays * (index - ray_count / 2.0)
		#ray.cast_to = Vector2.UP.rotated(angle) * max_view_distance
#		add_child(ray)
#		ray.enabled = true
#
func _physics_process(delta: float) -> void:
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
#	for ray in get_children():
#		if ray.is_colliding() and get_collider() is Player:
#			target = _ray.get_collider()
#			break
#
#	var does_see_player := target != null
func on_hit():
	health -= 1
	if health <= 0:
		die()

func die():
	queue_free()

func _on_Detector_body_entered(body):
	if body is PlayerController:
		player = body
		fire()
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
