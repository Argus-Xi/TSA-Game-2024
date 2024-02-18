extends Control

export var heart_size = 64

#references

onready var empty_hearts = $empty_hearts

onready var live_hearts = $live_hearts

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = Global.hearts_visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	visible = Global.hearts_visible
	empty_hearts.rect_size.x = heart_size * Global.player_total_lives / 2 # division allows for half-hearts
	live_hearts.rect_size.x = heart_size * Global.player_health / 2
