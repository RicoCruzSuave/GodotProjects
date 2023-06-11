shader_type spatial;

uniform sampler2D tex;
uniform float squish_factor;

float stepify(float a, float stepi) {
	return floor(a * stepi) / stepi;
}

void vertex() {
	float tex_r = (texture(tex, UV).r);
	float tex_b = (texture(tex, UV).b);
	VERTEX.y += stepify(tex_r, 5.0) / squish_factor;
//	VERTEX.y -= tex_b / squish_factor;
}

void fragment() {
	float tex_r = texture(tex, UV).r;
	ALBEDO.rgb = vec3(stepify(tex_r, 5.0));
//	if (tex_r > 0.3) {
//		ALBEDO.rgb = vec3(0.1, 0.5, 0.1);
//	} 
//	if (tex_r < 0.2) {
//		ALBEDO.rgb = vec3(0.1, 0.1, 0.5);
//	}
}
