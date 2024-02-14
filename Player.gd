extends KinematicBody2D

class_name Player

#Signals

signal player_died_1


#references

onready var arrow_hit_box = $arrow_hit_box

onready var sword_sweep = $sword_sweep

onready var sword_sprite = $sword_sweep/sword_sprite

# VARIABLES

# movement
export var speed = 20
var omega = PI
var direction = Vector2.ZERO
var velocity = Vector2.ZERO


# combat variables
export var bow_cooldown_timer= 1
export var sword_cooldown_timer = 0.5
export var damage_cooldown_timer = 0.5
# var b = "text"
var have_bow= true
var have_sword = true
var bow_cooldown = true
var sword_cooldown = true
var damage_cooldown = true
var arrow= preload("res://Assets/combat/Arrow.tscn")

var damage = 1

# Health

var local_health

var total_lives

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = speed * 1000
	
	#Access saved variables from global simpleton
	total_lives = Global.player_total_lives
	local_health = Global.player_health
	
	arrow_hit_box.connect("area_entered", self, "on_arrow_hit_box_area_entered")
	sword_sprite.visible = false
	


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
		
	if Input.is_action_just_pressed("right_mouse") and bow_cooldown and have_bow:
		shoot()
	if Input.is_action_just_pressed("left_mouse") and sword_cooldown and have_sword:
		swing()
	
	if velocity != Vector2.ZERO:
		pass
	look_at(get_global_mouse_position())
	
	
	
	#rotation = direction.angle() # There's a problem: if you don't let go of two diagonals at the exact same time, it faces in the direction of the most recent diagonal released, which makes sense but is frustrating that it can't leave the player at diagonals. How to solve?
func _physics_process(delta):
	move_and_slide(velocity.normalized() * speed * delta)
	
	
	# arrow shot
	
	
	
		
		
func shoot():
	bow_cooldown=false
	var arrow_instance=arrow.instance()
	arrow_instance.rotation=rotation
	arrow_instance.global_position=global_position + Vector2(50,0).rotated(rotation) # added to get arrow away from player - no self damage
	add_child(arrow_instance)
	
	yield(get_tree().create_timer(bow_cooldown_timer),"timeout")
	bow_cooldown=true
	
func swing():
	sword_sprite.visible = true
	print(sword_sweep.get_overlapping_bodies())
	for body in sword_sweep.get_overlapping_bodies():
		print(body.is_in_group("Enemy"))
		if body.is_in_group("Enemy"):
			body.apply_damage(damage)
			print("enemy hit from player")
	yield(get_tree().create_timer(0.3),"timeout")
	sword_sprite.visible = false
		
func apply_damage(damage: float):
	if damage_cooldown == true:
		print("player hurt")
		damage_cooldown = false
		local_health = clamp(local_health - damage, 0, total_lives)
		Global.player_health = local_health
		if local_health == 0.0:
			print("player died")
			death()
			
		# period of time when player is damaged but can't receive more damage - "immunity" phase
		yield(get_tree().create_timer(damage_cooldown_timer),"timeout")
		damage_cooldown = true
	
	
	
	
func death():
	emit_signal("player_died_1")
	
func on_arrow_hit_box_area_entered(area):
	if area.is_in_group("combat"):
		apply_damage(area.damage)
	

	
	
	
	
	
	
