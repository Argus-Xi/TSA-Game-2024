extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 100 
var omega = PI
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
export var bow_cooldown_timer= 1
# var b = "text"
var have_bow= true
var bow_cooldown = true
var arrow= preload("res://Assets/combat/Arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = speed * 1000
	print(typeof(get_viewport().get_mouse_position())) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("left"):
		velocity.x += -1
	if Input.is_action_pressed("right"):
		velocity.x += 1

	if Input.is_action_pressed("up"):
		velocity.y += -1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	
	if velocity != Vector2.ZERO:
		pass
	look_at(get_global_mouse_position())
	
	
	
	#rotation = direction.angle() # There's a problem: if you don't let go of two diagonals at the exact same time, it faces in the direction of the most recent diagonal released, which makes sense but is frustrating that it can't leave the player at diagonals. How to solve?
func _physics_process(delta):
	move_and_slide(velocity.normalized() * speed * delta)
	
	
	
	if Input.is_action_just_pressed("right_mouse") and bow_cooldown and have_bow:
		bow_cooldown=false
		var arrow_instance=arrow.instance()
		arrow_instance.rotation=rotation
		arrow_instance.global_position=global_position
		add_child(arrow_instance)
		
		yield(get_tree().create_timer(bow_cooldown_timer),"timeout")
		bow_cooldown=true
