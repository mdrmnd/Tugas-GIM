extends Actor


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


# Ambil arah dari vektor berdasarkan input
func get_direction() -> Vector2:
	return Vector2(
		# Arah kanan (+1) dikurangi arah kiri (-1), jadi kalo dipencet bareng bisa 0
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		# Arah atas (-1), kalau tidak sedang lompat maka arah bawah (+1)
		-1.0 if Input.is_action_just_pressed("Jump") and is_on_floor() else 1.0
	)
