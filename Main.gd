extends Node

export (PackedScene) var Mob # let us choose our mob
var score

# Declare member variables here. Examples:
var difficulty = 0
var mobNum = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() # seed randomizer for mob
	$MobTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Handler for player.hit
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

# called when start button is hit, resets everything
func new_game():
	score = 0
	difficulty = 0
	mobNum = 3
	$Player.start($StartPosition.position)
	
	# Special case for start screen
	$MobTimer.stop()
	
	$StartTimer.start()
	$HUD.update_score(score) # set score to 0
	$HUD.show_message("prepare\nyour body")

# Timer to increment score every second
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

# Start other timers
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

# Timer to spawn a mob, called every .5 seconds
func _on_MobTimer_timeout():
	
	if(difficulty < 30 ): # Introduce a slight difficulty bump at 15 sec
		difficulty += 1
		if( difficulty == 30 ): # 2 calls/sec * 15 seconds = 30 sec
			mobNum += 1
	
	for i in range(mobNum):
		mobSpawn()

func mobSpawn():
	# Set random location on curve
	$MobPath/MobSpawnLocation.set_offset(randi())
	
	# create mov instance and add to scene
	var mob = Mob.instance()
	add_child(mob) # add as child to Main
	
	# Set mob's position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	
	# Set mob's direction perpendicular to path to face in
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2
	# Add some randomness to direction
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction
	
	# set velocity
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
	# respond to any start_game signal
	$HUD.connect("start_game", mob, "_on_start_game")