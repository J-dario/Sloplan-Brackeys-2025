extends Node3D

var playerSlop = 0

func addPlayerSlop(amount: int):
	playerSlop += amount
	
func removePlayerSlop(amount: int):
	playerSlop -= amount

func getPlayerSlop():
	return playerSlop
