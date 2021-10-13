extends KinematicBody2D
class_name Actor

onready var _animated_sprite = get_node("AnimatedSprite")

var velocity := Vector2.ZERO
var speed := Vector2(300.0, 650.0)
var gravity := 1000.0
