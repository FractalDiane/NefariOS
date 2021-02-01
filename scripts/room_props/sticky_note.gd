extends Spatial

export(String, MULTILINE) var note_contents: String


func set_note_text(text: String) -> void:
	(get_node("../ViewportNote/StickyNoteText/Text") as RichTextLabel).set_bbcode(text)
	var tex := (get_node("../ViewportNote") as Viewport).get_texture()
	tex.set_flags(ViewportTexture.FLAG_FILTER)
	get_node("Cube004").get_surface_material(0).set_shader_param("viewport_texture", tex)


func cross_off_file(file_name: String) -> void:
	var label := get_node("../ViewportNote/StickyNoteText/Text") as RichTextLabel
	#label.bbcode_text = label.bbcode_text.replace(file_name, "[s]" + file_name + "[/s]")
	label.bbcode_text = label.bbcode_text.replace(file_name, file_name + " (FOUND)")
