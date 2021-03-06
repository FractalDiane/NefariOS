extends Spatial

onready var screen_viewport := get_node("../Viewport") as Viewport
onready var screen := get_node("../Viewport/Screen") as Screen


func _ready() -> void:
	var tex := screen_viewport.get_texture()
	tex.set_flags(ViewportTexture.FLAG_FILTER)
	get_node("Cube").get_surface_material(3).set_shader_param("viewport_texture", tex)
