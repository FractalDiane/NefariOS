shader_type canvas_item;

void fragment()
{
	vec3 c = texture(TEXTURE, UV).rgb * COLOR.rgb;
	float y = 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b;
	COLOR = vec4(y, y, y, 1.0);
}