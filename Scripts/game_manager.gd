extends Node3D

@onready var label: Label = $"../Label"
@onready var slop_lan: Node3D = $"../SlopLan"
@onready var camera_3d: Camera3D = $"../Camera3D"

var playerSlop = 0

func addPlayerSlop(amount: int):
	playerSlop += amount
	label.text = str("Slop: ", playerSlop)
	
func removePlayerSlop(amount: int):
	playerSlop -= amount
	label.text = str("Slop: ", playerSlop)


func getPlayerSlop():
	return playerSlop

func loseGames():
	camera_3d.lock()
	slop_lan.activate()
