extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var starting_cutscene : PackedScene = preload("res://level/cutscenes/Cutscene1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_button_down():
	#get_tree().change_scene("res://level/cutscenes/Cutscene1.tscn")
	for child in get_children():
		child.visible = false
	var scene = starting_cutscene.instance()
	add_child(scene)
