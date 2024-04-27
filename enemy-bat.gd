extends RigidBody2D

signal killed
@export var healthBar = 20
@export var damage = 10
@export var xpDrop = 10
func _ready():
	$AnimatedSprite2D.animation = "fly_left"
	$AnimatedSprite2D.play()
	healthBar = 20


func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	var groups = body.get_groups()
	if groups[0] == "shot":
		healthBar -= 5
		$ProgressBar.value = (healthBar*100)/20
		if healthBar <= 0:
			emit_signal("killed", xpDrop,$".".position )
			queue_free()
	
