extends Area2D
signal hit #For collissions
signal end_game #For end game
@export var speed = 400 #how fast the player will move (pixelss/sec).
var screen_size #size of game window
var lives #number of lives
var inv = false #invincible for a certain amount of time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO #players movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		if inv == false:
			$AnimatedSprite2D.animation = "walk"
		else:
			$AnimatedSprite2D.animation = "hit_walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		if inv == false:
			$AnimatedSprite2D.animation = "up"
		else:
			$AnimatedSprite2D.animation = "hit_up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	pass


func _on_body_entered(body: Node2D) -> void:
	#hide() #Player disappears after being hit
	if inv == false:
		
		lives -= 1
		if lives <= 0:
			lives = 0
		hit.emit(lives)
		$InvincibleTimer.start()
		inv = true
		if lives <= 0:
			hide() #player disappears after end of health
			end_game.emit()
			#Must be deferred as we can't change physics properties on a phsysics callback
			$CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.

func start(pos,mainLive):
	position = pos
	lives = mainLive
	show()
	$AnimatedSprite2D.animation = "walk"
	$CollisionShape2D.disabled = false

func _on_invincible_timer_timeout() -> void:
	inv = false
	$InvincibleTimer.stop()
	pass # Replace with function body.
