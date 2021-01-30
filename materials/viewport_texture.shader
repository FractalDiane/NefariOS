shader_type spatial;

uniform sampler2D viewport_texture : hint_albedo;
uniform vec2 uv_offset;

void fragment() {
	ALBEDO = texture(viewport_texture, UV + uv_offset).rgb;
}
