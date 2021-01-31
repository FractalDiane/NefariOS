extends Program


const SHADER := preload("res://materials/grayscale.shader")

var window: Panel
var scroll_container: ScrollContainer
var image: TextureRect
var image_file: NOSImageFile

func _exec(args: Array) -> void:
	image_file = args[0]
	window = open_window(Rect2(Vector2(9 * 4, 16 * 4), Vector2(9 * 50, 16 * 20)), image_file.file_name)
	
	scroll_container = AlignedScrollContainer.new()
	window.add_child(scroll_container)
	scroll_container.anchor_right = Control.ANCHOR_END
	scroll_container.anchor_bottom = Control.ANCHOR_END
	scroll_container.margin_right = 0
	scroll_container.margin_bottom = 0
	scroll_container.scroll_horizontal_enabled = true
	
	image = TextureRect.new()
	image.texture = image_file.texture
	var shader = ShaderMaterial.new()
	shader.shader = SHADER
	image.material = shader
	
	scroll_container.add_child(image)
	

