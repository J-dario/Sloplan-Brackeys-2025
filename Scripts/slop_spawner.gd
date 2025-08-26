extends Node3D

const SLOP = preload("res://Scenes/slop.tscn")
const GOLD_SLOP = preload("res://Textures/goldSlop.png")
const PRISMATIC_SLOP = preload("res://Textures/prismaticSlop.png")

@onready var game_manager: Node3D = $"../GameManager"
@onready var slopContainer: Node3D = $SlopContainer
@onready var spawnArea: CollisionShape3D = $SpawnArea/CollisionShape3D

var spawnPoint

func _input(event: InputEvent):
	if event.is_action_pressed("zoomIn"):
		spawnSlop(100, 0)
	elif event.is_action_pressed("test"):
		removeSlop(77)

func spawnSlop(amount: int, flag: bool):
	if !flag:
		game_manager.addPlayerSlop(amount)
	var prismaticCount = floor(amount / 100)
	var goldCount = floor((amount % 100) / 10)
	var basicCount = amount % 10

	for i in prismaticCount:
		spawnSlopType(2)
	for i in goldCount:
		spawnSlopType(1)
	for i in basicCount:
		spawnSlopType(0)
	
func removeSlop(amount: int):
	if game_manager.getPlayerSlop() < amount:
		print("Error: Not enough slop to remove")
		return

	game_manager.removePlayerSlop(amount)
	var prismatic_nodes = findSlops("prismatic")
	var gold_nodes = findSlops("gold")
	var basic_nodes = findSlops("basic")

	for i in range(prismatic_nodes.size()):
		if amount >= 100:
			prismatic_nodes[i].queue_free()
			amount -= 100
		elif amount > 0:
			var remaining_value = 100 - amount
			prismatic_nodes[i].queue_free()
			spawnSlop(remaining_value, 1)
			amount = 0
			break

	for i in range(gold_nodes.size()):
		if amount >= 10:
			gold_nodes[i].queue_free()
			amount -= 10
		elif amount > 0:
			var remaining_value = 10 - amount
			gold_nodes[i].queue_free()
			spawnSlop(remaining_value, 1)
			amount = 0
			break

	for i in range(basic_nodes.size()):
		if amount >= 1:
			basic_nodes[i].queue_free()
			amount -= 1
		if amount <= 0:
			break

func spawnSlopType(type: int):
	var instance = SLOP.instantiate()
	slopContainer.add_child(instance)
	instance.global_transform.origin = getRandomSpawnPoint()
	
	if type == 0:
		instance.set_meta("slop_type", "basic")
		
	elif type == 1:
		var slopMesh = instance.get_node("SlopMesh") as MeshInstance3D
		var mat = slopMesh.mesh.surface_get_material(0).duplicate()
		mat.albedo_texture = GOLD_SLOP
		slopMesh.set_surface_override_material(0, mat)
		instance.set_meta("slop_type", "gold")
		
	elif type == 2:
		var slopMesh = instance.get_node("SlopMesh") as MeshInstance3D
		var mat = slopMesh.mesh.surface_get_material(0).duplicate()
		mat.albedo_texture = PRISMATIC_SLOP
		slopMesh.set_surface_override_material(0, mat)
		instance.set_meta("slop_type", "prismatic")
	
func getRandomSpawnPoint():
	var extents = spawnArea.shape.extents
	var randX = randf_range(-extents.x, extents.x)
	var randY = randf_range(-extents.y, extents.y)
	var randZ = randf_range(-extents.z, extents.z)
	var randomPoint = Vector3(randX, randY, randZ)
	return spawnArea.global_transform.origin + randomPoint

func findSlops(slop_type: String) -> Array:
	var matches = []
	for child in slopContainer.get_children():
		if child.has_meta("slop_type") and child.get_meta("slop_type") == slop_type:
			matches.append(child)
	return matches
