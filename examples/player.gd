extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var ap: AnimationPlayer = %AnimationPlayer
@onready var base_sprite: Sprite2D = %BaseSprite


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Reload Scene
	if Input.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
	# Exit Game
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	animate(direction)
	move_and_slide()

func animate(direction):
	if direction > 0:
		base_sprite.scale.x = 1
	elif direction < 0:
		base_sprite.scale.x = -1
	if is_on_floor():
		if direction:
			ap.play("walk")
		else:
			ap.play("idle")
	else:
		if velocity.y > 0:
			ap.play("fall")
		else:
			ap.play("jump")
