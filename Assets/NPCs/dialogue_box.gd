extends Node2D


onready var title_node = $panel/title

onready var content_node = $panel/content

export var time_per_character = 0.02

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		# resumes time when interact key is pressed
		Global.time = 1
		visible = false


# Types out the title and content sent by an npc
func type(title, content):
	# initial delay to make sure the signal to make it disappear has passed
	yield(get_tree().create_timer(time_per_character),"timeout")
	
	# pauses time for the dialogue
	Global.time = 0
	title_node.text = title
	content_node.text = content
	content_node.visible_characters = 0
	visible = true # shows the panel
	
	# allows characters to scroll in
	for _n in range(0, content_node.text.length()):
		yield(get_tree().create_timer(time_per_character),"timeout")
		content_node.visible_characters += 1
