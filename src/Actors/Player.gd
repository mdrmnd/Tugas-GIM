extends Actor

var crouching := false

onready var normCol := get_node("NormalCollision")
onready var crouCol := get_node("CrouchCollision")

func _on_NormalDetector_area_entered(area: Area2D) -> void:
	velocity.y = -speed.y


func _on_NormalDetector_body_entered(body: Node) -> void:
	queue_free()
	get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	var direction := get_direction()
	# Cek apakah player melepas tombol jump dan player sedang di udara
	var is_jump_interrupted := Input.is_action_just_released("Up") and velocity.y<0
	
	if direction.x==0:
		velocity.x = lerp(velocity.x, 0, 0.1)
	else:
		velocity.x = lerp(velocity.x, (speed.x-int(crouching)*0.8*speed.x) * direction.x, 1.0)
	if is_on_wall():
		velocity.y = 0
	elif not is_on_floor():
		if is_on_ceiling():
			velocity.y = 0
		velocity.y += gravity * delta
	
	if direction.y != 0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Kecepatan oleh lompatan langsung 0 dan selanjutnya dipengaruhi gravitasi saja jika kondisi terpenuhi
		# Supaya tinggi lompatan ditentukan oleh lamanya player memberi input "Jump"
		velocity.y = 0.0
	if Input.is_action_pressed("Down"):
		if is_on_floor():
			toggle_crouch(true)
		else:
			velocity.y = speed.y
	elif Input.is_action_just_released("Down") and not is_on_ceiling():
		toggle_crouch(false)
	elif crouching and not is_on_ceiling():
		toggle_crouch(false)
		
	play_animation(velocity)
	move_and_slide(velocity, Vector2.UP)


# Ambil arah dari vektor berdasarkan input
func get_direction() -> Vector2:
	# Arah kanan (+1) dikurangi arah kiri (-1), jadi kalo dipencet bareng bisa 0
	var x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var y = 0
	if Input.get_action_strength("Up")>0:
		if is_on_wall():
			if (_animated_sprite.flip_h and x>0) or (not _animated_sprite.flip_h and x<0):
				y = -1.0
		elif is_on_floor():
			y = -1.0
	else:
		y = 0.0
	return Vector2(x, y)
	
	
func play_animation(linear_velocity: Vector2) -> void:
	if linear_velocity.x>0:
		_animated_sprite.flip_h = false
	elif linear_velocity.x<0:
		_animated_sprite.flip_h = true
	if is_on_floor():
		if abs(linear_velocity.x)>50:
			if crouching:
				_animated_sprite.play("crawl")
			elif Input.get_action_strength("Right")==0 and Input.get_action_strength("Left")==0:
				_animated_sprite.play("idle_transition")
			else:
				_animated_sprite.play("run")
		else:
			if crouching:
				_animated_sprite.play("crouch")
			else:
				_animated_sprite.play("idle")
	elif is_on_wall():
		if linear_velocity.y<0:
			_animated_sprite.play("ledge_climbing")
		else:
			_animated_sprite.play("ledge_hang")
	else:
		if Input.is_action_pressed("Up"):
			_animated_sprite.play("jump_rise")
		elif velocity.y<=0:
			_animated_sprite.play("jump_mid")
		else:
			_animated_sprite.play("jump_fall")

func toggle_crouch(status: bool) -> void:
	if not status:
		crouching = false
		normCol.disabled = false
		crouCol.disabled = true
	else:
		crouching = true
		normCol.disabled = true
		crouCol.disabled = false
