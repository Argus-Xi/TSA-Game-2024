extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 100
var omega = PI
var direction = Vector2.ZERO
var velocity = Vector2.ZERO

# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	look_at(get_global_mouse_position())
	rotation_degrees+=90
	if Input.is_action_pressed("left"):
		velocity.x += -1
	if Input.is_action_pressed("right"):
		velocity.x += 1

	if Input.is_action_pressed("up"):
		velocity.y += -1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if velocity != Vector2.ZERO:
		direction = velocity
	
	position += velocity.normalized() * speed * delta
