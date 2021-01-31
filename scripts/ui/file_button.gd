extends Button
class_name FileButton

var sound1 := preload("res://audio/sfx/hover_1.ogg") as AudioStream
var sound2 := preload("res://audio/sfx/hover_2.ogg") as AudioStream
var sound3 := preload("res://audio/sfx/select.ogg") as AudioStream


func _ready() -> void:
	connect("mouse_entered", self, "play_hover_sound")
	connect("pressed", self, "play_click_sound")
	

func play_hover_sound() -> void:
	GlobalSignals.emit_signal("play_keyboard_sound")
	
	
func play_click_sound() -> void:
	GlobalSignals.emit_signal("play_keyboard_enter_sound")
