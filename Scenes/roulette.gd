extends Node3D
class_name Roulette

@export var default_circle_spin_speed : float = 0.25

@onready var mesh_circle := $Roulette
@onready var mesh_wood := $Wood


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	mesh_circle.rotate_y(default_circle_spin_speed * delta)
