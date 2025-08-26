extends Camera3D

enum CameraState { BACK, LEFT_WALL, SLOP_HOUSE, TABLE, SHOP, RIGHT_WALL }
var currentState: CameraState = CameraState.TABLE

var rotationSpeed: float = 8.0
var targetRotationY: float = 0.0

var zoomSpeed: float = 6.0
var targetZoomPos: Vector3
var targetZoomRot: Vector3
var zoomed = false
var canMove = true

func _ready():
	targetRotationY = rotation.y
	targetZoomPos = global_position
	targetZoomRot = global_rotation

func _process(delta: float):
	rotation.y = lerp_angle(rotation.y, targetRotationY, rotationSpeed * delta)
	global_position = global_position.lerp(targetZoomPos, zoomSpeed * delta)

	rotation.x = lerp_angle(rotation.x, targetZoomRot.x, zoomSpeed * delta)
	rotation.z = lerp_angle(rotation.z, targetZoomRot.z, zoomSpeed * delta)
	
func _input(event: InputEvent):
	if canMove:
		if event.is_action_pressed("lookRight"):
			handleLook(45)
		elif event.is_action_pressed("lookLeft"):
			handleLook(-45)
		elif event.is_action_pressed("zoomIn"):
			handleZoom(1)
		elif event.is_action_pressed("zoomOut"):
			handleZoom(0)

func handleZoom(direction: int):
	if direction == 0:
		targetZoomPos = Vector3(-22, 9, 0)
		targetZoomRot = Vector3(0, deg_to_rad(-90), 0)
		zoomed = false
	else:
		zoomed = true
		if currentState == CameraState.TABLE:
			targetZoomPos = Vector3(-5, 12, 0)
			targetZoomRot = Vector3(deg_to_rad(-40), deg_to_rad(-90), 0)
		elif currentState == CameraState.SHOP:
			targetZoomPos = Vector3(-17, 9, 14)
		elif currentState == CameraState.RIGHT_WALL:
			targetZoomPos = Vector3(-29, 9, 18)
		elif currentState == CameraState.SLOP_HOUSE:
			targetZoomPos = Vector3(-11, 9, -15)
		elif currentState == CameraState.LEFT_WALL:
			targetZoomPos = Vector3(-29, 9, -18)

func handleLook(direction: int):
	var states = CameraState.values()
	var idx = states.find(currentState)
	var prevState = idx
	
	if direction > 0:
		idx = (idx - 1) % states.size()
	elif direction < 0:
		idx = (idx + 1 + states.size()) % states.size()
	currentState = states[idx]
	
	if currentState == 0 or prevState == 0:
		direction*=2
		
	if zoomed == true:
		handleZoom(0)
		
	targetRotationY += deg_to_rad(direction)
	print(currentState)

func lock():
	canMove = false
	handleZoom(0)
	targetRotationY = deg_to_rad(90)
