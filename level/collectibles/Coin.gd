extends Area2D

export (String) var type = "coin"
export (int) var value = 4

signal item_pickup


func _ready():
	self.connect("body_entered", self, "_on_Coin_body_entered")



func _on_Coin_body_entered(body):
	if body.get_name() == "Player":
		CoinSystem.add_coin()
		queue_free()
	
