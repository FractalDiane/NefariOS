shader_type spatial;
render_mode unshaded;

uniform sampler2D viewport_texture : hint_albedo;
uniform int scanline_height = 4;
uniform float scanline_darkness : hint_range(0f, 1f) = 0.6;
uniform float screen_brightness : hint_range(0f, 1f) = 1f;
uniform vec2 uv_scale = vec2(1f);
uniform vec2 uv_offset = vec2(0f);

void fragment() {
	ALBEDO = texture(viewport_texture, UV * uv_scale + uv_offset).rgb;
	ALBEDO *= 1f - (scanline_darkness * float(int(FRAGCOORD.y) % scanline_height != 0));
	ALBEDO *= screen_brightness;
}
