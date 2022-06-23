extends Camera2D


func _ready():
	pass 
	
func _process(delta):
	$PlayerUI/CoinCounter.text = str(CoinSystem.score)
	$PlayerUI/PositionLabel.text = "Current Position: " + str(get_parent().position)
