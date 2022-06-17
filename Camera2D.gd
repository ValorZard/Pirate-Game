extends Camera2D


func _ready():
	pass 
	
func _process(delta):
	$Label.text = str(CoinSystem.score)
