extends Spatial


func _ready() -> void:
	var tex := (get_node("../Viewport") as Viewport).get_texture()
	tex.set_flags(ViewportTexture.FLAG_FILTER)
	get_node("Cube").get_surface_material(3).set_shader_param("viewport_texture", tex)
