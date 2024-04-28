extends CanvasLayer

@export var btn_option : PackedScene
signal optionSelected
var options = [
	{"sprite": "sprite-velocity-improvement.png", "type": "velocity_player", "value": "20", "title": "Melhore a velocidade de movimento", "description": "Aumente a velocidade em"},
	{"sprite": "sprite-attack-damage-improvemente.png", "type": "damage_player", "value": "5", "title": "Melhore o dano de ataque", "description": "Aumente a dano de ataque em"},
	{"sprite": "sprite-attack-rate-improvement.png", "type": "attack_rate", "value": "5", "title": "Melhore a velocidade de ataque", "description": "Aumente a velocidade de ataque em"},
	{"sprite": "sprite-health-improvement.png", "type": "health_player", "value": "20", "title": "Melhore a vida", "description": "Aumente a vida em"}
]

var sprites = {}  # Dictionary to store preloaded sprites

func _ready():
	preload_sprites()
	
func _process(delta):
	pass

func preload_sprites():
	for option in options:
		var sprite_path = "res://" + option["sprite"]
		sprites[option["sprite"]] = load(sprite_path)

func _add_options():
	options.shuffle()
	var randomOptions = options.slice(0, 3)
	var space = 10
	for option in randomOptions:
		var button = btn_option.instantiate()
		button.get_node("Description").text = option["description"] + " " + option["value"]
		button.get_node("Title").text = option["title"]
		var sprite_icon = button.get_node("SpriteIcon")
		sprite_icon.texture = load("res://arts/" + option.sprite)
		button.position = Vector2(40,space)
		space += 100  
		button.connect("button_down", _button_pressed.bind(option))
		$Panel.add_child(button)
		
func _button_pressed(option):
	emit_signal("optionSelected",option)
