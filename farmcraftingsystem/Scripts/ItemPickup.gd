extends Node2D
class_name ItemPickup

var speed = 200
var target : Node2D = null
@export var item : CropResource
var stack_count : int = 1

func _physics_process(delta: float) -> void:
	if target:
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body

func _on_delete_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.on_picked_up_item(item, stack_count)
		queue_free()
