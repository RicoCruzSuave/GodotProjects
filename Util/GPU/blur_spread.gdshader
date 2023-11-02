shader_type canvas_item;

uniform sampler2D feedbackTex;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	
	vec4 center = texture(feedbackTex, UV);
	vec4 left = texture(feedbackTex, UV + vec2(-TEXTURE_PIXEL_SIZE.x, 0.0));
	vec4 right = texture(feedbackTex, UV + vec2(TEXTURE_PIXEL_SIZE.x, 0.0));
	vec4 up = texture(feedbackTex, UV + vec2(0.0, -TEXTURE_PIXEL_SIZE.y));
	vec4 down = texture(feedbackTex, UV + vec2(0.0, TEXTURE_PIXEL_SIZE.y));
	
	COLOR = (center + left + right + up + down) / 6.5;
	
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
