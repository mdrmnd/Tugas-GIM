extends Actor

"""
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		_animated_sprite.play("jump_rise")
	elif velocity.y<0:
		_animated_sprite.play("jump_mid")
	elif velocity.y>0:
		_animated_sprite.play("jump_fall")
	if Input.is_action_pressed("Right"):
		_animated_sprite.flip_h = false
		if is_on_floor():
			_animated_sprite.play("run")
	elif Input.is_action_pressed("Left"):
		_animated_sprite.flip_h = true
		if is_on_floor():
			_animated_sprite.play("run")
	elif Input.is_action_just_released("Right"):
		_animated_sprite.flip_h = false
		_animated_sprite.play("idle_transition")
	elif Input.is_action_just_released("Left"):
		_animated_sprite.flip_h = true
		_animated_sprite.play("idle_transition")
	elif is_on_floor():
		_animated_sprite.play("idle")
"""
func _physics_process(delta: float) -> void:
	move_and_slide(velocity, Vector2.UP)
	var direction := get_direction()
	# Cek apakah player melepas tombol jump dan player sedang di udara
	var is_jump_interrupted := Input.is_action_just_released("Jump") and velocity.y<0
	
	velocity.x = speed.x * direction.x
	velocity.y += gravity * delta
	
	if direction.y == -1.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Kecepatan oleh lompatan langsung 0 dan selanjutnya dipengaruhi gravitasi saja jika kondisi terpenuhi
		# Supaya tinggi lompatan ditentukan oleh lamanya player memberi input "Jump"
		velocity.y = 0.0
	if Input.is_action_pressed("Plunge"):
		velocity.y = 750

	play_animation(velocity)


# Ambil arah dari vektor berdasarkan input
func get_direction() -> Vector2:
	return Vector2(
		# Arah kanan (+1) dikurangi arah kiri (-1), jadi kalo dipencet bareng bisa 0
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		# Arah atas (-1), kalau tidak sedang lompat maka arah bawah (+1)
		-1.0 if Input.is_action_just_pressed("Jump") and is_on_floor() else 0.0
	)
	
func play_animation(linear_velocity: Vector2) -> void:
	if linear_velocity.x>0:
		_animated_sprite.flip_h = false
	elif linear_velocity.x<0:
		_animated_sprite.flip_h = true
	if is_on_floor():
		if linear_velocity.x!=0:
			_animated_sprite.play("run")
		elif Input.is_action_just_released("Right") or Input.is_action_just_released("Left"):
			_animated_sprite.play("idle_transition")
		else:
			_animated_sprite.play("idle")
	else:
		if Input.is_action_pressed("Jump"):
			_animated_sprite.play("jump_rise")
		elif velocity.y<=0:
			_animated_sprite.play("jump_mid")
		else:
			_animated_sprite.play("jump_fall")
