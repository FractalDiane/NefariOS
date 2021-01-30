shader_type spatial;
render_mode unshaded;

uniform sampler2D viewport_texture : hint_albedo;
uniform int scanline_height = 4;

void fragment() {
	ALBEDO = texture(viewport_texture, UV).rgb;
	ALBEDO *= 1f - (0.5 * float(int(FRAGCOORD.y) % scanline_height != 0));
}
