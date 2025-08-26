extends Node3D

@onready var label: Label = $"../Label"

var playerSlop = 0

func addPlayerSlop(amount: int):
	playerSlop += amount
	label.text = str("Slop: ", playerSlop)
	
func removePlayerSlop(amount: int):
	playerSlop -= amount
	label.text = str("Slop: ", playerSlop)


func getPlayerSlop():
	return playerSlop
