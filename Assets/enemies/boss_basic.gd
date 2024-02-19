extends KinematicBody2D


export var title = "Boss Name"

var local_health = 20

export var start_dialogue = "The Boss has noticed you!"

export var end_dialogue = "You beat the boss!"

export var total_lives = 20

export var damage = 3

export var force = 150

export var speed = 1

export var rot_speed = 0.5 # for idle

export var notice_range = 1000

export var transition_time = 1.0

export var lunge_parameter = 150

export var archer_parameter = 200

export var time_between_states = 5

export(PackedScene) var item_drop

export(PackedScene) var key_reference

var countdown = 0

var long_countdown = 0

var state = 0

var same_screen_as_player = false
# State comes in 4 stages: 
# 0: Idle, shuffle, wait
# 1: Notice
# SHORT RANGE
# 2: Approach
# 3: Pause, ends with attack and loops to 2
# 4: attack after a lunge (potentially)
# LONG RANGE
# 5: jump to archer's spot or starting position
# 6: archery mode: shoot

# PHYSICS variables:
var thrust = 0 # percentage of speed
var rot_thrust = 0 # percentage of idle rotating speed
var applied_force = Vector2.ZERO

#References

var player_pos = Vector2(0,0)

var start_pos = Vector2(0,0)

var projectile= preload("res://Assets/combat/projectile.tscn")

var health_increase = preload("res://Assets/collectibles/heart_increase.tscn")

onready var attack_box = $attack_box

onready var alert_pos = $alert_pos

onready var boss_ui = $boss_UI

onready var title_label = $boss_UI/Title

onready var healthbar = $boss_UI/healthbar

var rng = RandomNumberGenerator.new()

var viewport_size

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport().size
	local_health = total_lives
	
	speed = speed * 1000 # for some reason move_and_slide is very slow
	start_pos = position
	
	#boss ui
	title_label.text = title
	healthbar.max_value = total_lives
	healthbar.value = local_health
	boss_ui.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
# accesses the player's position every frame to check if it should attack and provide navigation
	for player in get_tree().get_nodes_in_group("player"):
		# checks if player is in the same screen as the enemy; otherwise the players position is (0,0)
		if floor(player.position.x / viewport_size.x) * viewport_size.x == floor(position.x / viewport_size.x) * viewport_size.x and floor(player.position.y / viewport_size.y) * viewport_size.y == floor(position.y / viewport_size.y) * viewport_size.y:
			player_pos = player.position
			same_screen_as_player = true
		else:
			state = 0 # only in idle mode if player is out of the viewport
			player_pos = Vector2(0,0)
			same_screen_as_player = false
			
	#keeps enemy in bounds:
	if floor(start_pos.x / viewport_size.x) * viewport_size.x != floor(position.x / viewport_size.x) * viewport_size.x or floor(start_pos.y / viewport_size.y) * viewport_size.y != floor(position.y / viewport_size.y) * viewport_size.y:
		position = start_pos # hacky fix, but it works.
		
	#updating health bar
	if state > 1:
		boss_ui.visible = true
	else:
		boss_ui.visible = false


	if countdown > 0: # do whatever you're doing
		countdown -= delta * Global.time # if time is stopped, the enemies can't update
	elif countdown <= 0 and same_screen_as_player: # don't update unless the enemy is in the same screen as the player
		update_state()
		
	long_countdown -= delta * Global.time # used to change between long and short-range states
	if state > 1 and long_countdown < 0:
		if state >= 2 and state <= 4:
			state = 5
		if state >= 5:
			state = 2
		long_countdown = time_between_states
		
		
func _physics_process(delta):
	move_and_slide(Vector2.RIGHT.rotated(rotation) * speed * thrust * delta * Global.time)
	move_and_slide(applied_force * delta * Global.time * 100)
	applied_force = applied_force * 0.8
	rotation += rot_speed * rot_thrust * delta * Global.time
		

# switching the state case with countdown
func update_state():
	print(state)
	
	if state == 0: # Still in wait and search state
			thrust = 0
			rot_thrust = 0
			if position.distance_to(player_pos) < notice_range: # change to notice/alert state, only if facing player
				state = 1
				alert_pos.visible = true
				countdown = transition_time
				get_tree().call_group("dialogue", "type", title, start_dialogue)
				
# Boss doesn't have idle motions
#			else: # All the things it does while idly waiting: pauses, moves forward, rotates, all randomly
#				var randint = rng.randi_range(0,2)
#				if randint == 0:
#					thrust = 0
#					rot_thrust = 0
#					countdown = transition_time
#					print("paused")
#				elif randint == 1:
#					thrust = 0.5
#					rot_thrust = 0
#					countdown = transition_time / 4
#					print("moved")
#				elif randint == 2:
#					thrust = 0
#					rot_thrust = rng.randi_range(-1, 1)
#					countdown = rng.randf_range(0.5, 2.0)
#					print("rotated")
#
	elif state == 1: # in notice/alert state
		alert_pos.visible = false
		look_at(player_pos)
		countdown = transition_time # quickly updates where it's moving to catch player
		state = 5
		long_countdown = time_between_states # once state is greater than 0, boss begins infinite flipflop between 
	elif state == 2: # approach state
		if position.distance_to(player_pos) <= lunge_parameter: # within range, move to state 3
			look_at(player_pos)
			thrust = -0.5 # slowly move back: spring to pounce
			state = 3
			countdown = transition_time / 2
		else: # out of range, keep moving forward
			look_at(player_pos)
			apply_force(position + Vector2.RIGHT.rotated(rotation + PI), speed) # sudden, jolting movements, not smooth like enemies
			countdown = transition_time
	elif state == 3: # attack after pause
		apply_force(position + Vector2.RIGHT.rotated(rotation - PI), speed * 3)
		state = 4
		countdown = transition_time / 4
	elif state == 4: # Lunge attack after having lunged
		swing()
		state = 2
	elif state == 5: # Moving back to archery starting position
		look_at(start_pos)
		apply_force(Vector2.RIGHT.rotated(rotation + PI), 50) # jump back to starting position (or in direction of)
		state = 6
		long_countdown = 15
	elif state == 6: # shooting from start position
		look_at(player_pos)
		shoot()
		countdown = transition_time
		
		
	
		
		
			

func apply_damage(local_damage: float):
	local_health = clamp(local_health - local_damage, 0, total_lives)
	healthbar.value = local_health
	if state == 0: # enemy notices the player if they're hit
		state = 1
	
	# Death
	if local_health == 0:
		get_tree().call_group("dialogue", "type", title, end_dialogue)
		var hi = health_increase.instance()
		hi.position = position
		get_parent().add_child(hi)
		if item_drop != null:
			var id = item_drop.instance()
			id.position = position
			get_parent().add_child(id)
		if key_reference != null:
			var key = key_reference.instance()
			key.position = position + Vector2.RIGHT * 30
			get_parent().add_child(key)
		queue_free()
		
func apply_force(pos: Vector2, intensity):
	applied_force = Vector2(position.x - pos.x, position.y - pos.y).normalized() * intensity
	print("force applied to enemy")

func _on_arrow_hit_box_area_entered(area):
	if area.is_in_group("combat"):
		apply_damage(area.damage)
		

func _on_pushback_body_entered(body): # keeps the player at bay during archery mode
	if body.name == "Player" and state == 6:
		body.apply_force(position, force)

func shoot():
	var projectile_instance=projectile.instance()
	projectile_instance.rotation=rotation
	projectile_instance.global_position=global_position + Vector2(100,0).rotated(rotation)
	add_child(projectile_instance)
	
func swing():
	for body in attack_box.get_overlapping_bodies():
		print("body found by enemy")
		if body.is_in_group("player"):
			print("body is detected as player")
			body.apply_damage(damage)
			body.apply_force(position, force)
	yield(get_tree().create_timer(transition_time),"timeout")


