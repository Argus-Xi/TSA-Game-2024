extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (NodePath) var player_nodepath = null

var player_pos = null

var viewport_size






# Called when the node enters the scene tree for the first time.
func _ready():
	player_pos = get_node(player_nodepath)
	
	viewport_size = get_viewport().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = floor(player_pos.position.x / viewport_size.x) * viewport_size.x
	position.y = floor(player_pos.position.y / viewport_size.y) * viewport_size.y
#	pass
