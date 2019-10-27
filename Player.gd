extends Area2D
signal hit # will send out a signal called hit

# Declare member variables here. Examples:
export var speed = 400 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$CollisionShape2D.disabled = true # no collision until game starts
	hide() #hide on initial start

# Start/restart game
func start(pos):
	position = pos # set position to start
	show() # be visible
	$CollisionShape2D.disabled = false # ensure collision enabled

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2() # The player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		# We don't want diagonal movement to be too fast, normalize it to keep dir
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		# if no input, don't do anything
		$AnimatedSprite.stop()
	
	# move as much as expected since last frame (delta is func parameter)
	position += velocity * delta
	# restrict position to within the screen size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false # we're moving left/right, no vert
		$AnimatedSprite.flip_h = velocity.x < 0 # if moving left, flip
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		# flip_h doesn't matter, symmetrical
		$AnimatedSprite.flip_v = velocity.y > 0 # if moving down, flip

# handler for when another body enters player
func _on_Player_body_entered(body):
	hide() # Player disappears after being hit
	emit_signal("hit")
	# disables collision, only when safe
	$CollisionShape2D.set_deferred("disabled", true)
