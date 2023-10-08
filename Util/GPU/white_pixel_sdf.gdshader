shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform int check_dist = 10;


void fragment() {
	vec4 screen_tex = texture(SCREEN_TEXTURE, SCREEN_UV);
	float current_pixel = screen_tex.r;
	float value = 0.0;
	float up = 0.0;
	float left = 0.0;
	float down = 0.0;
	float right = 0.0;	
	vec2 pixel_size = SCREEN_PIXEL_SIZE;
	vec2 uv = SCREEN_UV;
	for (int i = 0; i <= check_dist; i++) {
		float check_pixel = texture(SCREEN_TEXTURE, uv + vec2(-pixel_size.x * float(i),0)).r;
		left = float(i) / float(check_dist);
		if (check_pixel < 0.5 && current_pixel > 0.5) {
			break;
		}
		if (check_pixel > 0.5 && current_pixel < 0.5) {
			break;
		}
	}
	for (int i = 0; i < check_dist; i++) {
		float check_pixel = texture(SCREEN_TEXTURE, uv + vec2(pixel_size.x * float(i),0)).r;
		right = float(i) / float(check_dist);
		if (check_pixel < 0.5 && current_pixel > 0.5) {
			break;
		}
		if (check_pixel > 0.5 && current_pixel < 0.5) {
			break;
		}
	}
	for (int i = 0; i < check_dist; i++) {
		float check_pixel = texture(SCREEN_TEXTURE, uv + vec2(0, -pixel_size.y * float(i))).r;
		up = float(i) / float(check_dist);
		if (check_pixel < 0.5 && current_pixel > 0.5) {
			break;
		}
		if (check_pixel > 0.5 && current_pixel < 0.5) {
			break;
		}
	}
	for (int i = 0; i < check_dist; i++) {
		float check_pixel = texture(SCREEN_TEXTURE, uv + vec2(0, pixel_size.y * float(i))).r;
		down = float(i) / float(check_dist);
		if (check_pixel < 0.5 && current_pixel > 0.5) {
			break;
		}
		if (check_pixel > 0.5 && current_pixel < 0.5) {
			break;
		}
	}
	COLOR.rgb = vec3(0.0);
	vec2 dir = vec2(0.5 + (right - left), 0.5 + (down - up));
	COLOR.r = dir.x;
	COLOR.g = dir.y;
	COLOR.a = 0.5;
}
