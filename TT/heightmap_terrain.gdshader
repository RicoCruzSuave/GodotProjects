shader_type spatial;

uniform vec3 high_color = vec3(1.0);
uniform vec3 mid_color = vec3(0.1, 1.0, 0.1);
uniform vec3 low_color = vec3(0.1, 0.1, 1.0);

uniform float high_threshold = 0.5;
uniform float low_threshold = 0.2;

uniform sampler2D heightmap; 

void fragment() {
	vec4 noise = texture(heightmap, UV);
	if (noise.r > high_threshold) {
		ALBEDO = high_color;
	} else if (noise.r < low_threshold) {
		ALBEDO = low_color;
	} else {
		ALBEDO = mid_color;
	}
}

void vertex() {
	vec4 noise = texture(heightmap, UV);
	float offset = noise.r - 0.5;
	offset = max(offset, low_threshold - 0.5);
	if (noise.r > low_threshold && noise.r < high_threshold) {
		offset /= 2.0;
	}
	VERTEX.y += offset;
}
