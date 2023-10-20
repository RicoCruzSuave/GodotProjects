shader_type canvas_item;

uniform float threshold = 0.5;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR = tex;
	if (tex.b > threshold) {
		COLOR.a = 0.0;
	}
}
