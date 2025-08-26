extends CharacterBody3D
class_name Ball

@export var start_speed := 5.0
@export var deceleration := 0.8
@export var fall_threshold := 1.0
@export var fall_speed := 0.5
@export var default_speed := 1.0

var circle_center : Vector3
var spin_offset : Vector3
var slot_offset : Vector3

enum State {
	Spinning,
	Falling,
	Landed,
	Custom
}
var current_state : State = State.Spinning

var spin_speed := default_speed
var spin_progress := 0.0
var closest_slot : Slot 

@onready var collider := $CollisionShape3D

func init(circle_center_: Vector3, spin_offset_: Vector3) -> void:
	circle_center = circle_center_
	spin_offset = spin_offset_
	current_state = State.Spinning
	
	spin_speed = start_speed
	position = spin_offset

func update_slots(slots: Array[Slot]):
	var dist := global_position.distance_squared_to(closest_slot.global_position) if closest_slot else INF
	for slot in slots:
		var new_dist := global_position.distance_squared_to(slot.global_position) 
		if new_dist < dist:
			dist = new_dist
			closest_slot = slot

func _physics_process(delta: float) -> void:	
	if current_state == State.Spinning:
		spin_speed -= deceleration * signf(spin_speed) * delta
		spin_progress += spin_speed * delta
		
		var radius := spin_offset.length()
		var tangential_speed := spin_speed * radius
		velocity.x = -sin(spin_progress) * tangential_speed
		velocity.z = -cos(spin_progress) * tangential_speed
		velocity.y = 0
		
		#print("%.2f" % spin_speed, " ", closest_slot.name if closest_slot else "none")
			
		if spin_speed <= fall_threshold:
			velocity += global_position.direction_to(circle_center) * fall_speed 
		

	elif current_state == State.Landed:
		var dir := global_position.direction_to(closest_slot.global_position)
		global_position = global_position.move_toward(closest_slot.global_position, fall_speed * 5 * delta)
		#position = move_toward(position, closest_slot.move_toward)
	
	move_and_slide()
	position.y = spin_offset.y

func on_touch_slot(slot: Slot):
	print("Touched %s" % slot.name)
	closest_slot = slot
	current_state = State.Landed
	collider.disabled = true
