extends KinematicBody2D


var local_health = 2

var total_lives = 2

var damage = 1

#References

var arrow= preload("res://Assets/combat/Arrow.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	shoot()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func apply_damage(damage: float):
	local_health = clamp(local_health - damage, 0, total_lives)
	if local_health == 0:
		queue_free()

func _on_arrow_hit_box_area_entered(area):
	if area.is_in_group("combat"):
		apply_damage(area.damage)

func shoot():
	var arrow_instance=arrow.instance()
	arrow_instance.rotation=rotation
	arrow_instance.global_position=global_position + Vector2(50,0).rotated(rotation)
	add_child(arrow_instance)
	
	yield(get_tree().create_timer(1),"timeout")
	shoot()
