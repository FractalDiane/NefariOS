extends Spatial

export(String, MULTILINE) var note_contents: String


func set_note_text(text: String) -> void:
	(get_node("../ViewportNote/StickyNoteText/Text") as RichTextLabel).set_text(text)
	var tex := (get_node("../ViewportNote") as Viewport).get_texture()
	tex.set_flags(ViewportTexture.FLAG_FILTER)
	get_node("Cube004").get_surface_material(0).set_shader_param("viewport_texture", tex)
