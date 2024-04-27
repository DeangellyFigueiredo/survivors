extends CanvasLayer

var options = ["velocity_player", "damage_player", "attack_rate", "velocity_player", "health_player"]

func _ready():
	_add_options()

func _process(delta):
	pass

func _add_options():
	options.shuffle()
	var randomOptions = options.slice(0,3)
	print(randomOptions)
	var space = 50
	for option in randomOptions:
		var button = Button.new() 
		button.text = option 
		button.position =  Vector2($Panel.position.x/4,space)
		space +=50
		$Panel.add_child(button)
