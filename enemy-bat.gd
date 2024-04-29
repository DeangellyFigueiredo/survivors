extends RigidBody2D

@export var player : Area2D
signal killed
@export var healthBar = 20
@export var damage = 10
@export var xpDrop = 50
var player_position
var target_position

func _ready():
	$AnimatedSprite2D.animation = "fly_left"
	$AnimatedSprite2D.play()
	healthBar = 20


func _process(delta):
	if player:
		pass
		
func _physics_process(delta):

	var position1 = Vector2(randf_range(-10, 10), randf_range(-10,10))
	var direction = ((player.position - position1) - $".".position).angle()
	$".".look_at(player.position)
	var velocity = Vector2(100, 0.0)
	$".".linear_velocity = velocity.rotated(direction)
	#$".".connect("collected",)
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	var groups = body.get_groups()
	if groups[0] == "shot":
		healthBar -= body.damage
		$ProgressBar.value = (healthBar*100)/20
		if healthBar <= 0:
			emit_signal("killed", xpDrop,$".".position)
			queue_free()
	
