extends KinematicBody2D




export var total_lives = 2

var local_health = 2

export var damage = 1

export var speed = 7

export var rot_speed = 1 # for idle

export var notice_range = 400

export var transition_time = 1.0

export var attack_dist = 60

export var lunge_parameter = 100

export var archer_parameter = 200

var countdown = 0

var state = 0

var same_screen_as_player = false
# State comes in 4 stages: 
# 0: Idle, shuffle, wait
# 1: Notice
# 2: Approach
# 3: Pause, ends with attack and loops to 2
# 4: attack after a lunge (potentially)

# PHYSICS variables:
var thrust = 0 # percentage of speed
var rot_thrust = 0 # percentage of idle rotating speed
var applied_force = Vector2.ZERO

#References

var player_pos = Vector2(0,0)

var arrow= preload("res://Assets/combat/projectile.tscn")

var heart_reference = preload("res://Assets/collectibles/heart.tscn")

onready var attack_box = $attack_box

onready var alert_pos = $alert_pos

var rng = RandomNumberGenerator.new()

var viewport_size

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport().size
	local_health = total_lives
	
	speed = speed * 1000 # for some reason move_and_slide is very slow


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


	if countdown > 0: # do whatever you're doing
		countdown -= delta * Global.time # if time is stopped, the enemies can't update
	elif countdown <= 0 and same_screen_as_player: # don't update unless the enemy is in the same screen as the player
		update_state()
		
		
func _physics_process(delta):
	move_and_slide(Vector2.RIGHT.rotated(rotation) * speed * thrust * delta * Global.time)
	move_and_slide(applied_force * delta * Global.time * 1000)
	applied_force = applied_force * 0.8
	rotation += rot_speed * rot_thrust * delta * Global.time
		

# switching the state case with countdown
func update_state():
	if state == 0: # Still in wait and search state
			thrust = 0
			rot_thrust = 0
			if position.distance_to(player_pos) < notice_range and position.direction_to(player_pos).dot(Vector2(1,0).rotated(rotation)) > 0: # change to notice/alert state, only if facing player
				state = 1
				alert_pos.visible = true
				countdown = transition_time
				rot_thrust = 0
				thrust = 0
			else: # All the things it does while idly waiting: pauses, moves forward, rotates, all randomly
				var randint = rng.randf_range(0,3)
				if randint <= 0.5:
					thrust = 0
					rot_thrust = 0
					countdown = transition_time
					print("paused")
				elif randint <=2.5:
					thrust = 0
					rot_thrust = rng.randi_range(-1, 1)
					countdown = rng.randf_range(0.5, 2.0)
					print("rotated")
				elif randint :
					thrust = 0.5
					rot_thrust = 0
					countdown = transition_time / 4
					print("moved")

					
	elif state == 1: # in notice/alert state
		alert_pos.visible = false
		look_at(player_pos)
		thrust = 1
		countdown = transition_time / 4 # quickly updates where it's moving to catch player
		state = 2
	elif state == 2: # approach state
		if position.distance_to(player_pos) <= attack_dist: # within range, move to state 3
			look_at(player_pos)
			thrust = -0.2 # slightly moves back 
			state = 3
			countdown = transition_time / 2 # time pauses until attack
		else: # out of range, keep moving forward
			look_at(player_pos)
			thrust = 1
			countdown = transition_time
	elif state == 3: # attack after pause
		if attack_dist < lunge_parameter:
			swing()
			state = 2
		elif attack_dist >= lunge_parameter and attack_dist < archer_parameter:
			thrust = 4
			state = 4
			countdown = transition_time / 4
		elif attack_dist >= archer_parameter:
			shoot()
			state = 2
	elif state == 4: # Lunge attack after having lunged
		swing()
		state = 2
		
	
		
		
			

func apply_damage(local_damage: float):
	local_health = clamp(local_health - local_damage, 0, total_lives)
	if state == 0: # enemy notices the player if they're hit
		state = 1
	if local_health == 0:
		var rndm = rng.randf_range(0,2)
		if rndm <= 1:
			var heart = heart_reference.instance()
			heart.position = position
			get_parent().add_child(heart)
		queue_free()
		
func apply_force(pos: Vector2, intensity):
	applied_force = Vector2(position.x - pos.x, position.y - pos.y).normalized() * intensity
	print("force applied to enemy")

func _on_arrow_hit_box_area_entered(area):
	if area.is_in_group("combat"):
		apply_damage(area.damage)

func shoot():
	var arrow_instance=arrow.instance()
	arrow_instance.rotation=rotation
	arrow_instance.global_position=global_position + Vector2(50,0).rotated(rotation)
	add_child(arrow_instance)
	
func swing():
	for body in attack_box.get_overlapping_bodies():
		print("body found by enemy")
		if body.is_in_group("player"):
			print("body is detected as player")
			body.apply_damage(damage)
			body.apply_force(position, damage * 20)
	yield(get_tree().create_timer(transition_time),"timeout")
