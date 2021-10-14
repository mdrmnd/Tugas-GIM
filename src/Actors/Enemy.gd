extends Actor

func _ready() -> void:
	set_physics_process(false)
	velocity.x = -speed.x*0.3
	_animated_sprite.flip_h = true


func _on_StompDetector_body_entered(body: Node) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()
	
	
func _physics_process(delta: float) -> void:
	velocity.y += gravity*delta
	if is_on_wall():
		velocity.x *= -1.0
	if velocity.x>0:
		_animated_sprite.flip_h = false
	else:
		_animated_sprite.flip_h = true
	velocity.y = move_and_slide(velocity, Vector2.UP).y


