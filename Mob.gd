extends RigidBody2D

# Declare member variables here. Examples:
export var min_speed = 250 # min speed range
export var max_speed = 450 # max speed range
var mob_types = ["walk", "swim", "fly"]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Pick random animation for each mob creator. calling randomize() in main
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_start_game():
	queue_free() # destroy all mobs at game start

# whenever mob leaves the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # delete itself
