extends Spatial

export(bool) var startup_sequence := false

func _ready() -> void:
	if startup_sequence:
		($AnimationPlayer as AnimationPlayer).play("Startup")
