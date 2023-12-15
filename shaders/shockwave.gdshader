shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 center = vec2(0.5, 0.5);
uniform float power = 0.05;
uniform float size = 0.0;
uniform float sharpness = 0.1;
uniform float thickness = 0.1;
varying vec2 worldPos;

void fragment() {
	
	vec2 frag_uv = SCREEN_UV;
	float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 aspect_uv = (frag_uv - vec2(0.5, 0.0)) / vec2(aspect_ratio, 1.0) + vec2(0.5, 0.0);
	float outer = 1.0 - smoothstep(size - sharpness, size, length(aspect_uv - worldPos));
	float inner = smoothstep(size - sharpness - thickness, size - thickness, length(aspect_uv - worldPos));
	
	float ring = outer * inner;
	vec2 displacement = normalize(aspect_uv - worldPos) * power;
	COLOR = texture(SCREEN_TEXTURE, frag_uv - displacement) * ring;
}