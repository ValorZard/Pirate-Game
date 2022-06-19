extends KinematicBody2D

var Player:Node
var angle_cone_of_vision := deg2rad(30.0)
var max_view_distance := 800.00
var angle_between_rays := deg2rad(5.0)

#func _process(delta):
	#var velocity = (Player.position - position).normalized() * speed

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
	var target
	pass
#	for ray in get_children():
#		if ray.is_colliding() and get_collider() is Player:
#			target = _ray.get_collider()
#			break
#
#	var does_see_player := target != null
