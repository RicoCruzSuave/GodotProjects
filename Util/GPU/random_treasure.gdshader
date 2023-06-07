shader_type canvas_item;

uniform bool enabled = false;
uniform sampler2D screen_texture : filter_nearest;

uniform vec4 treasure_color : source_color;
uniform float treasure_threshold = 5.0;
uniform float random_chance = 0.5;
uniform float scale = 1.0;
uniform float rand_seed = 0.0;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy + vec2(rand_seed, rand_seed + 1.0),
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void fragment() {
	vec4 screen_tex = texture(screen_texture, UV);
	vec2 pixel_size = TEXTURE_PIXEL_SIZE * scale;
	
	float tl = texture(screen_texture, UV + vec2(-pixel_size.x, -pixel_size.y)).r; // Top Left
	float cl = texture(screen_texture, UV + vec2(-pixel_size.x, 0)).r; // Center Left
	float bl = texture(screen_texture, UV + vec2(-pixel_size.x, pixel_size.y)).r; // Bottom Left
	float tc = texture(screen_texture, UV + vec2(0, -pixel_size.y)).r; // Top Center
	float bc = texture(screen_texture, UV + vec2(0, pixel_size.y)).r; // Bottom Center
	float tr = texture(screen_texture, UV + vec2(pixel_size.x, -pixel_size.y)).r; // Top Right
	float cr = texture(screen_texture, UV + vec2(pixel_size.x, 0)).r; // Center Right
	float br = texture(screen_texture, UV + vec2(pixel_size.x, pixel_size.y)).r; // Bottom Right
	
	
	float count = tl + cl + bl + tc + bc + tr + cr + br;
	if (count < treasure_threshold && random(floor(UV/pixel_size)) < random_chance) {
		COLOR = treasure_color;
	} else {
		COLOR = screen_tex;
	}
	if (screen_tex.r < 0.1) {
		COLOR = vec4(vec3(0.0), 1.0);
	}
	if (!enabled){
		COLOR = screen_tex;
	}
}
