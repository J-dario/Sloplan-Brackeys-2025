extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func activate():
	animation_player.play("lose")
