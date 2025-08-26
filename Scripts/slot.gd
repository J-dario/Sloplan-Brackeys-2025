extends Node3D
class_name Slot

signal activated

@onready var blocker := $Blocker/CollisionShape3D

@onready var hit1 := $Multhit1
@onready var hit2 := $Multhit2

var already_touched : Array[Ball] = []

func activate() -> void:
	print("Activated!")
	activated.emit()
	hit1.play()
	
func _on_detector_body_entered(body: Node3D) -> void:
	if body is Ball and not body in already_touched:
		var ball := body as Ball
		ball.on_touch_slot(self)
		already_touched.push_back(body)
		activate()
	
	# Clean up deleted balls
	for ball in already_touched:
		if not ball or ball.is_queued_for_deletion():
			already_touched.remove_at(already_touched.find(ball))
