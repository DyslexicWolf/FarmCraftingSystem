extends Node

var ui_panel : Panel

func _ready() -> void:
	ui_panel = $UI_Panel

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		ui_panel.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		ui_panel.visible = false
