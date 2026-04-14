shader_type canvas_item;

uniform vec3 steps = vec3(3.0);
uniform bool alpha_included = false;

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR.r = round(tex.r * steps.r) / steps.r;
	COLOR.g = round(tex.r * steps.b) / steps.b;
	COLOR.b = round(tex.r * steps.g) / steps.g;
	COLOR = COLOR * modulate;
	//if (alpha_included) {
		//COLOR.a = floor(tex.r * steps) / steps;
	//}
}