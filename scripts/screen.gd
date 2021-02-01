class_name Screen
extends Control

const MAIN_PROGRAM := preload("res://scripts/programs/file_manager.gd")

var phosphor_colors := [Color("#ff7800"), Color("#00ff00"), Color("#ffffff")]

var previous_color: Color

onready var text := $Text as RichTextLabel


func _ready() -> void:
	var index := int(rand_range(0, len(phosphor_colors)))
	$BackBufferCopy2/Phosphor.get_material().set_shader_param("phosphor_color", phosphor_colors[index])
	if get_tree().current_scene == self:
		run_main_program()


func set_screen_text(text_: String) -> void:
	text.set_text(text_)
	text.show()
	
	
func set_screen_color(color: Color) -> void:
	$BackBufferCopy2/Phosphor.get_material().set_shader_param("phosphor_color", color)
	
	
func flash_screen_red() -> void:
	previous_color = $BackBufferCopy2/Phosphor.get_material().get_shader_param("phosphor_color")
	set_screen_color(Color("#ff0000"))
	$TimerFlash.start()
	
	
func show_secret() -> void:
	$ColorRectSecret.show()
	$TextSecret.show()
	
	
func show_secret_2() -> void:
	$TextSecret.set_text("\n\n\n\n\n\n\n\n\n\n            				        RUN.")
	
	
func show_virus_particles(show: bool) -> void:
	($ParticlesVirus as Particles2D).set_emitting(show)

func run_main_program() -> void:
	var program := MAIN_PROGRAM.new()
	$Root.add_child(program)
	program.call_deferred("_exec", [GameLogic.player])


func _on_Timer_timeout() -> void:
	set_screen_color(previous_color)
