extends Area2D

signal collected
@export var ammount = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	if area.name == "Player":
		emit_signal("collected",ammount)
		queue_free()
