extends Node

@export var mob_scene: PackedScene
@export var shot_scene: PackedScene
@export var orb_scene : PackedScene
var score
var enemyKilled
@export var multiplicator : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_killed():
	game_over()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$AttackTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	enemyKilled = 0
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("shot","queu_free")
	get_tree().call_group("orb","queu_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$AttackTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.player = $Player
	var direction = ($Player.position - mob.position).angle()
	mob.position = mob_spawn_location.position
	mob.look_at($Player.position)
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	mob.connect("killed",_killed_enemy)
	add_child(mob)


func _killed_enemy(xpDrop, lastPosition):
	score += 5
	_drop_xp_orb(xpDrop,lastPosition)
	enemyKilled += 1
	$HUD/CurrentEnemyKilledLabel.text = str(enemyKilled)

	
func _drop_xp_orb(xp_value, lastPosition):
	var orb_xp = orb_scene.instantiate()
	orb_xp.position = lastPosition
	orb_xp.connect("collected",_update_level_bar)
	orb_xp.ammount = xp_value
	add_child(orb_xp)
	
	
func _update_level_bar(amount):
	$Player._xp_collected(amount)
	$HUD/LevelBar.value = ($Player.currentXp*100) / $Player.levelUpXp

func _on_score_timer_timeout():
	score += (1 * multiplicator)
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_hud_start_game():
	new_game()
	
func _on_attack_timer_timeout():
	var shot = shot_scene.instantiate()
	shot.position = $Player.position
	var last_movement = $Player.last_movement
	var direction 
	
	
	if Input.is_action_pressed("move_right") && Input.is_action_pressed("move_up"):
		direction = 7*PI / 4
	elif Input.is_action_pressed("move_left") && Input.is_action_pressed("move_up"):
		direction = -3*PI / 4
	elif Input.is_action_pressed("move_left") && Input.is_action_pressed("move_down"):
		direction = -5*PI / 4
	elif Input.is_action_pressed("move_right") && Input.is_action_pressed("move_down"):
		direction = -7*PI / 4
	elif last_movement == "idle_right":
		direction = 0
	elif last_movement == "idle_left":
		direction = PI
	elif last_movement == "idle_bottom":
		direction = PI / 2
	elif last_movement == "idle_up":
		direction = -PI / 2
	
	var velocity = Vector2(500, 0.0)
	shot.rotation = direction
	
	shot.linear_velocity = velocity.rotated(direction)
	
	add_child(shot)



func _on_player_level_uped():
	$HUD/CurrentLevelLabel.text = str($Player.currentLevel)
	$LevelUp.play()
