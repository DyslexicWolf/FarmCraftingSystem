extends CharacterBody2D
class_name Player

signal picked_up_item(item: ItemResource, stack_count: int)

var speed = 130.0
var direction
var isAttacking: bool = false
@onready var player_animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float):
	get_input()
	change_animation()
	move_and_slide()

func get_input():
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed

func change_animation():
	#y-axis is flipped in godot!!!
	if direction.y < 0:
		player_animated_sprite.play("run_back")
	elif direction.y > 0:
		player_animated_sprite.play("run_front")
	elif direction.x > 0:
		player_animated_sprite.flip_h = false
		player_animated_sprite.play("run_side")
	elif direction.x < 0:
		player_animated_sprite.flip_h = true
		player_animated_sprite.play("run_side")
	else:
		player_animated_sprite.play("idle")

func on_picked_up_item(item: ItemResource, stack_count: int):
	picked_up_item.emit(item, stack_count)
