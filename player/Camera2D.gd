extends Camera2D


func _ready():
	pass 
	
func _process(delta):
	$PlayerUI/CoinCounter.text = str(CoinSystem.score)
