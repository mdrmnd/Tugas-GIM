extends KinematicBody2D
class_name Actor

var velocity = Vector2.ZERO
var speed = 300
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	move_and_slide(velocity, Vector2(0,-1))
	velocity.x = 0
	velocity.y += 350*delta
	if Input.is_action_pressed("Right"):
		velocity.x = 300
	if Input.is_action_pressed("Left"):
		velocity.x = -300
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = -350
	if Input.is_action_pressed("Plunge"):
		velocity.y = 750
