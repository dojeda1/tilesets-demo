extends CharacterBody2D


const SPEED = 40.0
const JUMP_VELOCITY = -400.0
@onready var ap: AnimationPlayer = %AnimationPlayer
@onready var base_sprite: Sprite2D = %BaseSprite


func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_down", "ui_up")
	if direction_x or direction_y:
		velocity = Vector2(direction_x, -direction_y).normalized() * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Reload Scene
	if Input.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
	# Exit Game
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	animate(direction_x, direction_y)
	move_and_slide()

func animate(direction_x, direction_y):
	if direction_x > 0:
		base_sprite.scale.x = 1
	elif direction_x < 0:
		base_sprite.scale.x = -1
		
	if direction_x or direction_y:
		ap.play("walk")
	else:
		ap.play("idle")
