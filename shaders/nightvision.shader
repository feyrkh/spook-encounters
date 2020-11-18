// For Godot we have to specify the shader type. Since this shader goes on a ColorRect node, it's 2D and all 2D shaders are of type `canvas_item`.
shader_type canvas_item;

// I wanted to extend the original shader a bit by offering 2 params that could be customized via in the inspector or code.

// The amount of time that it takes to fade in from black to the night vision. A value lower than 1 will result in faster fade in times and a value higher than 1 will result in longer fade in times.
uniform float fade_in_delay = 1.0;
// The amount of grain applied to the night vision.
uniform float noise_amount = 0.25;

// Only difference here is that we don't need to specify `in` in the parameter.
float hash(float n)
{
	return fract(sin(n) * 43758.5453123);
}

// `mainImage` is always `fragment` in Godot and it takes no arguments.
void fragment()
{
    // Shadertoy has an `iResolution` global variable but we don't have access to that in Godot. The Godot docs recommend either using the following definition below or passing it in manually.
	vec2 i_resolution = 1.0 / SCREEN_PIXEL_SIZE;
	
    // `fragCoord` is `FRAGCOORD` in Godot.
	vec2 p = FRAGCOORD.xy / i_resolution;
	
	vec2 u = p * 2. - 1.;
	vec2 n = u * vec2(i_resolution.x / i_resolution.y, 1.0);
    // Instead of `iChannel0` we have `TEXTURE` and `SCREEN_TEXTURE` available to us and since we want this to be a screen shader we use `SCREEN_TEXTURE`.
	vec3 c = texture(SCREEN_TEXTURE, p).xyz;
	
    // Instead of `iTime` we use the global `TIME`.
	c += sin(hash(TIME)) * 0.01;
	c += hash((hash(n.x) + n.y) * TIME) * (0.5 * noise_amount);
	c *= smoothstep(length(n * n * n * vec2(0.075, 0.4)), 1.0, 0.4);
	c *= smoothstep(0.001, 3.5 * fade_in_delay, TIME) * 1.5;
	
	c = dot(c, vec3(0.2126, 0.7152, 0.0722)) * vec3(0.2, 1.5 - hash(TIME) * 0.1, 0.4);
	
    // `fragColor` is `COLOR` in Godot.
	COLOR = vec4(c, 1.0);
}