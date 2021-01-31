class_name Screen
extends Control

const MAIN_PROGRAM := preload("res://scripts/programs/file_manager.gd")

var phosphor_colors := [Color("#ff7800"), Color("#00ff00"), Color("#ffffff")]

onready var text := $Text as RichTextLabel


func _ready() -> void:
	if get_tree().current_scene == self:
		run_main_program()


func set_screen_text(text_: String) -> void:
	text.set_text(text_)
	text.show()

func run_main_program() -> void:
	var program := MAIN_PROGRAM.new()
	$Root.add_child(program)
	program.call_deferred("_exec", [GameLogic.player])
