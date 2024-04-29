extends Area2D
signal killed
signal levelUped
@export var currentLevel = 1
@export var currentXp = 0
@export var healthBar = 500
@export var maximumHealth =500
@export var speed = 100 
@export var attackDamage = 50
@export var levelUpXp =100
var screen_size 
var last_movement = "idle_bottom"

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	$Blood.hide()
	start(Vector2(562,-242))

func _process(delta):
	var velocity = Vector2.ZERO 
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
	$DamageReceived.play()
	
	if healthBar <= 0 :
		hide() 
		killed.emit()
		$CollisionShape2D.set_deferred("disabled", true)
	
func _got_hit(damage):
	healthBar -= damage
	$Blood.show()
	$Blood.play()
	$HealthBar.value = (100*healthBar)/maximumHealth

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$HealthBar.value = 100
	healthBar = 100
	currentLevel = 1
	currentXp = 0
	levelUpXp = 100

func _level_up():
	currentLevel += 1
	currentXp = 0
	healthBar = maximumHealth
	$HealthBar.value = (100*healthBar)/maximumHealth
	levelUpXp += currentLevel*20
	emit_signal("levelUped")

func _xp_collected(amount) : 
	currentXp += amount
	if currentXp >= levelUpXp:
		_level_up()



func _on_blood_animation_looped():
	$Blood.stop()
	$Blood.hide()

