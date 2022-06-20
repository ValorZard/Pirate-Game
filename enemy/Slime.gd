extends KinematicBody2D

#class_name Mobs

var player: PlayerController
export var health : int = 10

func _ready():
	add_to_group("mobs")

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
		var distance: Vector2
		distance = player.position - self.position
		move_and_slide(distance) #tracking, basically - snowy
	pass
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
	pass

func _on_Detector_body_exited(body):
	if body is PlayerController:
		player = null
	pass 
