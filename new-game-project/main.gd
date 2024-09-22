extends Node

@export var mob_scene: PackedScene
var score
#var lives

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	pass # Replace with function body.
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")
	$HUD.update_score(score)
	$HUD.update_lives(3)
	$HUD.show_message("Get Ready")
	$Music.play()
	

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_timer_timeout():
	 #create new instance of mob scene
	var mob = mob_scene.instantiate()
	
	#Choose random location on path2d
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	#Set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	#Set the mob's position to a rand location
	mob.position = mob_spawn_location.position
	
	#Add some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#Choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#Spawn the mob by adding it to main scene
	add_child(mob)
	
	
func _on_player_hit(lives) -> void:
	$HUD.update_lives(lives)
	pass # Replace with function body.
