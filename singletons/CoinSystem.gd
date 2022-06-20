extends Node

var score


func _ready():
	score = 0

func add_coin():
	score += 1
	print(score)
