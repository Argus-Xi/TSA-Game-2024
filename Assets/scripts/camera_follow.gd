extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (NodePath) var player_nodepath = null

var player_pos = null






# Called when the node enters the scene tree for the first time.
func _ready():
	player_pos = get_node(player_nodepath)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = floor(player_pos.position.x / 1920) * 1920
	position.y = floor(player_pos.position.y / 1080) * 1080
#	pass
