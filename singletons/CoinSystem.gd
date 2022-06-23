extends Node

var coin_amt : int


func _ready():
	coin_amt = 0

func add_coin():
	coin_amt += 1
	#print(score)
