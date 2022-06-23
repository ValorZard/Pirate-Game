extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player : PlayerController

# tier system

# set prices
export var level_one_price := 1
export var level_two_price := 2
export var level_three_price := 5

var reload_level : int = 0
#export var reload_percent_decrease : float = 0.8
export var reload_level_one : float = 0.6
export var reload_level_two : float = 0.5
export var reload_level_three : float = 0.25

export var heal_price : int = 1
export var heal_amt := 5

var rotate_level : int = 0
export var rotate_level_one : float = 1
export var rotate_level_two : float = 2
export var rotate_level_three : float = 5

var movement_level := 0
export var movement_level_one : float = 400
export var movement_level_two : float = 600
export var movement_level_three : float = 700

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	# SUPER FUCING FRAGILE
	player = get_parent().get_parent().get_parent().get_parent()
	# for testing purposes
	CoinSystem.coin_amt = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ReloadButton/ReloadLabel.text = "Decrease Cannon Reload Time (Current Level " + str(reload_level) + ")"
	$RotateButton/RotateLabel.text = "Increase Rotation Speed (Current Level " + str(rotate_level) + ")"
	$MovementButton/MovementLabel.text = "Increase Movement Speed (Current Level " + str(movement_level) + ")"


func _on_ReturnButton_button_down():
	self.visible = false
	SignalManager.emit_signal("end_dialog")


func _on_ReloadButton_button_down():
	if reload_level == 0:
		if CoinSystem.coin_amt >= level_one_price:
			player.max_time_to_reload = reload_level_one
			reload_level += 1
			CoinSystem.coin_amt -= level_one_price
	elif reload_level == 1:
		if CoinSystem.coin_amt >= level_two_price:
			player.max_time_to_reload = reload_level_two
			reload_level += 1
			CoinSystem.coin_amt -= level_two_price
	elif reload_level == 2:
		if CoinSystem.coin_amt >= level_three_price:
			player.max_time_to_reload = reload_level_three
			reload_level += 1
			CoinSystem.coin_amt -= level_three_price
			$ReloadButton.text = "MAXED OUT"


func _on_HealButton_button_down():
	if CoinSystem.coin_amt >= heal_price:
		player.health += heal_amt
		if player.health >= player.max_health:
			player.health = player.max_health
		CoinSystem.coin_amt -= heal_price
	


func _on_RotateButton_button_down():
	if rotate_level == 0:
		if CoinSystem.coin_amt >= level_one_price:
			player.rotation_speed = rotate_level_one
			rotate_level += 1
			CoinSystem.coin_amt -= level_one_price
	elif rotate_level == 1:
		if CoinSystem.coin_amt >= level_two_price:
			player.rotation_speed = rotate_level_two
			rotate_level += 1
			CoinSystem.coin_amt -= level_two_price
	elif rotate_level == 2:
		if CoinSystem.coin_amt >= level_three_price:
			player.rotation_speed = rotate_level_three
			rotate_level += 1
			CoinSystem.coin_amt -= level_three_price
			$RotateButton.text = "MAXED OUT"


func _on_MovementButton_button_down():
	if movement_level == 0:
		if CoinSystem.coin_amt >= level_one_price:
			player.speed = movement_level_one
			movement_level += 1
			CoinSystem.coin_amt -= level_one_price
	elif movement_level == 1:
		if CoinSystem.coin_amt >= level_two_price:
			player.speed = movement_level_two
			movement_level += 1
			CoinSystem.coin_amt -= level_two_price
	elif movement_level == 2:
		if CoinSystem.coin_amt >= level_three_price:
			player.speed = movement_level_three
			movement_level += 1
			CoinSystem.coin_amt -= level_three_price
			$MovementButton.text = "MAXED OUT"
