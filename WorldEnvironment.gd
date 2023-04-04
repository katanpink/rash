extends WorldEnvironment


# Called when the node enters the scene tree for the first time.
func _ready():
	# enable_dof()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_sky()

func rotate_sky():
	var rotation = get_environment().get_sky_rotation()
	var new_rotation = rotation + Vector3(0,0.001,0)
	get_environment().set_sky_rotation(new_rotation)

func enable_dof():
	var cam = get_camera_attributes()
	cam.dof_blur_far_enabled = true
