// For Godot we have to specify the shader type. Since this shader goes on a ColorRect node, it's 2D and all 2D shaders are of type `canvas_item`.
shader_type canvas_item;

float remap(float value, float inputMin, float inputMax, float outputMin, float outputMax)
{
	return (value - inputMin) * ((outputMax - outputMin) / (inputMax - inputMin)) + outputMin;
}

float rand(vec2 n, float time)
{
	return 0.5 + 0.5 * fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453 + time);
}

vec4 mask_blend(vec4 a, vec4 b)
{
	vec4 one = vec4(1.0, 1.0, 1.0, 1.0);
	return one - (one - a) * (one - b);
}

float f1(float x)
{
	return -4.0 * pow(x - 0.5, 2.0) + 1.0;
}

// `mainImage` is always `fragment` in Godot and it takes no arguments.
void fragment()
{
    // Shadertoy has an `iResolution` global variable but we don't have access to that in Godot. The Godot docs recommend either using the following definition below or passing it in manually.
	vec2 iResolution = (1.0 / SCREEN_PIXEL_SIZE);
	
    // `fragCoord` is `FRAGCOORD` in Godot.
	vec2 uv = FRAGCOORD.xy / iResolution.xy;
	
	float wide = iResolution.x / iResolution.y;
	float high = 1.0;
	
	vec2 position = vec2(uv.x * wide, uv.y);
	
	float greenness = 0.4;
	vec4 coloring = vec4(1.0 - greenness, 1.0, 1.0 - greenness, 1.0);
	
    // Instead of `iTime` we use the global `TIME`.
	float noise = rand(uv * vec2(0.1, 1.0), TIME * 5.0);
	float noiseColor = 1.0 - (1.0 - noise) * 0.3;
	vec4 noising = vec4(noiseColor, noiseColor, noiseColor, 1.0);
	
	float warpLine = fract(-TIME * 0.5);
	
	float warpLen = 0.1;
	float warpArg01 = remap(clamp((position.y - warpLine) - warpLen * 0.5, 0.0, warpLen), 0.0, warpLen, 0.0, 1.0);
	float offset = sin(warpArg01 * 10.0)  * f1(warpArg01);
	
	vec4 lineNoise = vec4(1.0, 1.0, 1.0, 1.0);
	if(abs(uv.y - fract(-TIME * 19.0)) < 0.0005)
	{
		lineNoise = vec4(0.5, 0.5, 0.5, 1.0);
	}
	
    // Instead of `iChannel0` we have `TEXTURE` and `SCREEN_TEXTURE` available to us and since we want this to be a screen shader we use `SCREEN_TEXTURE`.
	vec4 base = texture(SCREEN_TEXTURE, uv + vec2(offset * 0.02, 0.0));
	COLOR = base * coloring * noising * lineNoise;
}