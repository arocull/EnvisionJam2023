shader_type spatial;

render_mode skip_vertex_transform;

const vec3 col = vec3(0.3f,0.3f,0.3f);
const vec3 sparkle = vec3(1.0f, 1.0f, 1.0f);
const float timescale = 0.05f;
uniform sampler2D noise;
uniform sampler2D sparkles;
uniform float coverage = 0.0f;

void vertex() {
	vec3 dir = vec3(0.0f,0.0f,-1.0f);//MODELVIEW_MATRIX.xyz;
	float dp = clamp((dot(normalize(VERTEX), dir) / 2.0f) + 0.5f, 0.0f, 1.0f);
	COLOR = vec4(VERTEX.xyz, dp);
	
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

float seamless_texture(in sampler2D tex, in vec2 coordA, in vec2 coordB, in float height) {
	// Sample UV noise and world-space noise
	// Then blend noise values based on height, to create a seamless texture
	return mix(texture(tex, coordA).x, texture(tex, coordB).x, height);
}

void fragment() {
	vec2 offset = vec2(TIME * timescale, TIME * timescale);
	float height = 1.0f - sin(PI * UV.y);
	
	// Sample UV noise and world-space noise
	vec2 coordA = UV;
	vec2 coordB = (COLOR.xz / 2.0f);
	
	// Blend noise values based on height, to create a seamless texture
	float lumin = seamless_texture(noise, coordA + offset, coordB + offset, height);
	offset /= 3.0f;
	float spark = pow(seamless_texture(sparkles, coordA - offset, coordB - offset, height), 1.5f);
	
	ALBEDO = mix(col, sparkle, spark);
	ROUGHNESS = clamp(lumin - spark, 0.6f, 1.0f) * 0.9f;
	SPECULAR = lumin * 0.5f;
}
