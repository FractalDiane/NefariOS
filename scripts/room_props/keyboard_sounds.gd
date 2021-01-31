extends Spatial


export(Array, AudioStream) var hover_sounds: Array

onready var click_sound := $ClickSound as AudioStreamPlayer3D
onready var enter_sound := $EnterSound as AudioStreamPlayer3D
onready var tele_sound := $TeleSound as AudioStreamPlayer3D
onready var area := $Area as Area
onready var shape := $Area/CollisionShape.shape as BoxShape


func _ready() -> void:
	GlobalSignals.connect("play_keyboard_sound", self, "play_hover_sound")
	GlobalSignals.connect("play_keyboard_enter_sound", self, "play_enter_sound")
	GlobalSignals.connect("play_teleport_sound", self, "play_teleport_sound")

func play_hover_sound() -> void:
	hover_sounds.shuffle()
	var sound := hover_sounds[0] as AudioStream
	
	var pitch := rand_range(0.9, 1.1)
	
#	var new_position: Vector3 = Vector3(
#		rand_range(-shape.extents.x, shape.extents.x),
#		0,
#		rand_range(-shape.extents.z, shape.extents.z)
#	) + area.global_transform.origin
#	click_sound.global_transform.origin = new_position
	
	click_sound.stream = sound
	click_sound.pitch_scale = pitch
	click_sound.play()


func play_enter_sound() -> void:
	enter_sound.pitch_scale = rand_range(0.9, 1.1)
	enter_sound.play()


func play_teleport_sound() -> void:
	tele_sound.pitch_scale = rand_range(0.9, 1.2)
	tele_sound.play()
