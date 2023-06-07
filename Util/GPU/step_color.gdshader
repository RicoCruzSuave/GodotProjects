shader_type canvas_item;

uniform float steps = 2.0;
uniform bool alpha_included = false;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR.r = round(tex.r * steps) / steps;
	COLOR.g = round(tex.r * steps) / steps;
	COLOR.b = round(tex.r * steps) / steps;
	if (alpha_included) {
		COLOR.a = floor(tex.r * steps) / steps;
	}
}