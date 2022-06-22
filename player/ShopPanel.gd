extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ReturnButton_button_down():
	self.visible = false
	SignalManager.emit_signal("end_dialog")


func _on_ReloadButton_button_down():
	pass # Replace with function body.


func _on_HealButton_button_down():
	pass # Replace with function body.


func _on_RotateButton_button_down():
	pass # Replace with function body.


func _on_MovementButton_button_down():
	pass # Replace with function body.
