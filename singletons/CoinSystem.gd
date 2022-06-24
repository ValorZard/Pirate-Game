extends Node

var coin_amt : int


func _ready():
	coin_amt = 5

func add_coin():
	coin_amt += 1
	#print(score)
