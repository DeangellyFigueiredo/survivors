extends Area2D
signal killed
@export var healthBar = 50
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var last_movement = "idle_bottom"
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	start(Vector2(562,-242))

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		if velocity.x > 0:
			$AnimatedSprite2D.animation = "walk_right"
			last_movement = "idle_right"
		if velocity.x < 0:
			$AnimatedSprite2D.animation = "walk_left"	
			last_movement = "idle_left"

	elif velocity.y != 0:
		if velocity.y > 0:
			$AnimatedSprite2D.animation = "walk_bottom"	
			last_movement = "idle_bottom"
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "walk_up"
			last_movement = "idle_up"
			
	if velocity.x == 0 && velocity.y == 0:
		$AnimatedSprite2D.animation = last_movement	


func _on_body_entered(body):
	_got_hit(body.damage)
	if healthBar <= 0 :
		hide() # Player disappears after being hit.
		killed.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		#we can't change physics properties on a physics callback.
	
func _got_hit(damage):
	healthBar -= damage
	$ProgressBar.value = (100*healthBar)/50

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$ProgressBar.value = 100
	healthBar = 50

