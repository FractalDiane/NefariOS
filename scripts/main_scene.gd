extends Spatial

export(bool) var startup_sequence := false
export(Resource) var file_to_display: Resource

var boot_text := [
	"\n\n\tChecking boot disk...",
	"\n\n\n\tReading configuration data...",
	"\n\n\tInitializing filegraph table...",
	"\n\n\n\tPerforming final setup...",
]

func _ready() -> void:
	if startup_sequence:
		($AnimationPlayer as AnimationPlayer).play("Startup")
	
	GameLogic.running_main_scene = true


func add_boot_text(index: int) -> void:
	($Viewport/Screen/BootText as RichTextLabel).text += boot_text[index]


func clear_screen() -> void:
	($Viewport/Screen as Screen).set_screen_text("")
	$Viewport/Screen/BootText.hide()
	$Viewport/Screen/Logo.hide()
	
	
func show_start_text() -> void:
	($Viewport/Screen as Screen).set_screen_text(file_to_display.text)
	
	
func show_virus_particles(show: bool) -> void:
	($Viewport/Screen as Screen).show_virus_particles(show)


func _input(event: InputEvent) -> void:
	$Viewport.input(event)
