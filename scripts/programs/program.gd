extends Node
class_name Program


func open_window(rect: Rect2, title: String) -> Panel:
	var window := WindowContainer.new()
	window.title = title
	window.rect_position = ScreenHelper.align_and_clamp(rect.position)
	window.rect_size = ScreenHelper.align_and_clamp(rect.size)
	
	get_parent().add_child(window)
	
	return window


func open_root_window(title: String) -> Panel:
	var window := Panel.new()
	
	window.rect_position = Vector2(9, 16)
	window.rect_size = Vector2(720 - (9 * 2), 400 - (16 * 2))
	
	var label := Label.new()
	window.add_child(label)
	label.text            = title
	label.grow_horizontal = Label.GROW_DIRECTION_BOTH
	label.anchor_left     = 0.5
	label.anchor_right    = 0.5
	label.margin_left     = 0
	label.margin_right    = 0
	label.rect_size       = Vector2()
	label.rect_position.y = -15
	label.rect_position.x = floor(label.rect_position.x / 9) * 9
	
	get_parent().add_child(window)
	
	return window


func exec(executable: String, args: Array = []) -> void:
	var script := load("res://scripts/programs/" + executable + ".gd") as GDScript
	var program := script.new() as Program
	get_parent().add_child(program)
	program._exec(args)


func default_open_file(file: NOSFile) -> void:
	if file is NOSTextFile:
		exec("less", [file])
	elif file is NOSImageFile:
		exec("imgview", [file])


func _exec(args: Array) -> void:
	pass
