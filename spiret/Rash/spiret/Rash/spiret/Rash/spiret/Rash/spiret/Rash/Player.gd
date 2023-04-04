extends CharacterBody3D

@export var SPEED = 3.7
@export var WALK = 2.25
@export var ACCEL = 5.0
@export var JUMP_VELOCITY = 3.5
var RUN = false

func _ready():
	$AnimationPlayer.play("movement")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if not velocity.y == 0 || not is_on_floor():
		if velocity.y >= 0.7:
			$AnimationPlayer.play('fs_up')
		elif velocity.y >= 0.3:
			$AnimationPlayer.play('up')
		elif velocity.y >= -0.3:
			$AnimationPlayer.play('dn')
		elif velocity.y <= -0.3:
			$AnimationPlayer.play('fs_dn')

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("run"):
		RUN = true
	else:
		RUN = false
	var input_dir = Input.get_axis("move_left", "move_right")
	if RUN == true:
		velocity.x = lerp(velocity.x, input_dir * SPEED, 0.2) 
	else:
		velocity.x = input_dir * WALK
	if input_dir == 0:
		velocity.x = lerp(velocity.x, 0.0, 0.4) 


	
	# Call animation helpers
	#update_facing(input_dir)
	if velocity.x != 0:
		if velocity.x > ACCEL:
			velocity.x = ACCEL
		if velocity.x < -ACCEL:
			velocity.x = -ACCEL
		if is_on_floor():
			$AnimationPlayer.play("movement")
			if velocity.x < 0:
				$Sprite3D.flip_h = true
			else:
				$Sprite3D.flip_h = false
	
	if velocity.x == 0 && velocity.y == 0:
		$AnimationPlayer.play("idle")
	#update_animation()
	
	move_and_slide()



