# https://www.youtube.com/watch?v=sVsn9NqpVhg

extends RigidBody3D

# Controls speed of camera proportially with mouse input
var mouse_sensitivity := 0.001
# Keeps track of horizontal mouse input
var twist_input := 0.0
# Keeps track of vertical mouse input
var pitch_input := 0.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

# Called when the node enters the scene tree for the first time.
func _ready():
	# Wait for mouse input
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Movement for Character
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	input.y = Input.get_axis("jump")
	# TODO
	# 1. Gravity and Jump
	# 2. Character movement over rough terrain is not smooth
	
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta)
	
	# Check if ESC key pressed and show mouse cursor
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Prevent issues with the vertical mouse movement	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
		deg_to_rad(-30), 
		deg_to_rad(30)
	)
	twist_input = 0.0
	pitch_input = 0.0

# Run every time a n event is detected that is not handled by another script
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		# Prevent camera movement when ESC key pressed
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
	
