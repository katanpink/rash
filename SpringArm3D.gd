extends SpringArm3D

# var TPS_POSITION = Vector3(0,0,1) # 0
# const FPS_POSITION = Vector3(0,0,0) # 1

@export var camera_distance = 1
const CAMERA_MAX_DISTANCE = 5
@export var current_perspective = 0
@export var rotation_divisor = 180
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_released("zoom_in") and current_perspective == 0:
		if current_perspective == 0 and camera_distance <CAMERA_MAX_DISTANCE:
			increase_zoom()

	if Input.is_action_just_released("zoom_out") and current_perspective == 0:
		if current_perspective == 0 and camera_distance >1:
			decrease_zoom()
	
	handle_camera_rotation()
	
func handle_camera_rotation():
	var y = rotation.y
	if !Input.is_action_pressed("run"):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self,"rotation:y", y + PI/rotation_divisor, 0.5)
	elif Input.is_action_pressed("rotate_right"):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self,"rotation:y", y - PI/rotation_divisor, 0.2)


func decrease_zoom():
	camera_distance -=1
	TPS_POSITION.z = camera_distance
	update_camera()

func increase_zoom():
	camera_distance +=1
	TPS_POSITION.z = camera_distance
	update_camera()


var TPS_POSITION = Vector3(0,0,1) # 0
const FPS_POSITION = Vector3(0,0,0) # 1

func change_view():
	if current_perspective != 1:
		current_perspective +=1
	else:
		current_perspective = 0
		# reset FPS changes to player spring arm and camera rotation
		rotation.y = 0
		$Camera.rotation.x = 0
	update_camera()


func update_camera():
	var tween = create_tween()
	# tween.set_trans(Tween.TRANS_EXPO)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	# change to TPS
	if current_perspective == 0:
		tween.tween_property($Camera,"position", TPS_POSITION, 0.5).from_current()
		self.spring_length = camera_distance
	# change to FPS
	if current_perspective == 1:
		tween.tween_property($Camera,"position", FPS_POSITION, 0.5).from_current()
		self.spring_length = 0

func _unhandled_input(event: InputEvent) -> void:
	if current_perspective == 1: #  and current_perspective == 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif current_perspective == 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.001) # need a similar condition for handling mouse rotation in TPS
			$Camera.rotate_x(-event.relative.y * 0.001)
			$Camera.rotation.x = clamp($Camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
