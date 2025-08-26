extends Node3D
class_name Roulette

@export var default_circle_spin_speed : float = 0.25
@export var main_edge_pos : Vector3 = Vector3.ZERO

const ball_prefab = preload("res://Scenes/ball.tscn")
const slot_prefab = preload("res://Scenes/slot.tscn")

@onready var edge_point := $EdgePoint
@onready var slot_point := $SlotPoint
@onready var circle := $Circle

var wheel_speed : float = 0.0
var slots : Array[Slot] = []
var balls : Array[Ball]

func _ready() -> void:
	for i in range(18):
		var slot := slot_prefab.instantiate() as Slot
		slot.name = "Slot%s" % str(i)
		var angle := deg_to_rad(i * 20)
		slot.position = slot_point.position.rotated(Vector3.UP, angle)
		slot.rotation_degrees.y = rad_to_deg(angle)
		$Circle/Slots.add_child(slot)
		slots.push_back(slot)
	slot_point.queue_free()
	
	var ball := ball_prefab.instantiate() as Ball
	ball.init(circle.global_position, main_edge_pos)
	balls.push_back(ball)
	add_child(ball)

var prog := 0.0

func _process(delta: float) -> void:
	wheel_speed = default_circle_spin_speed
	circle.rotate_y(wheel_speed * delta)
	
	for ball in balls:
		ball.update_slots(slots)
