extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("warning"):
		$AnimationPlayer.play("Fadeout")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Fadeout":
		get_tree().change_scene("res://scenes/main.tscn")
