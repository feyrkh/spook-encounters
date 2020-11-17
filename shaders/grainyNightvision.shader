// For Godot we have to specify the shader type. Since this shader goes on a ColorRect node, it's 2D and all 2D shaders are of type `canvas_item`.
shader_type canvas_item;

// The original shader contains these variables below with `#define` but since we don't have access to that we just declare them as uniforms instead.

// The amount of grain to apply to the night vision.
uniform float noise = 0.2;
// The amount that the screen should flicker.
uniform float flicker = 0.02;
// Affects how bright the night vision effect is.
uniform float luminance = 0.5;

// `mainImage` is always `fragment` in Godot and it takes no arguments.
void fragment() {
    // Shadertoy has an `iResolution` global variable but we don't have access to that in Godot. The Godot docs recommend either using the following definition below or passing it in manually.
	vec2 i_resolution = 1.0 / SCREEN_PIXEL_SIZE;

	// Normalized pixel coordinates (from 0 to 1)
    // `fragCoord` is `FRAGCOORD` in Godot.
	vec2 uv = FRAGCOORD.xy / i_resolution.xy;

	// scene color
    // Instead of `iChannel0` we have `TEXTURE` and `SCREEN_TEXTURE` available to us and since we want this to be a screen shader we use `SCREEN_TEXTURE`.
	vec4 color = texture(SCREEN_TEXTURE, uv) * vec4(0.5, 0.9, 0.52, 1.0);

	// vigenette
	float d = length(uv - 0.5);
	float c = 1.0;
	// float c = 1.3 - d;
	float vignette = smoothstep(0.5, 1.0, c);

	// Luminance
	color = luminance * color;

	// simple noise effect
    // Instead of `iTime` we use the global `TIME`.
	float noise_2 = noise * fract(sin(dot(uv, vec2(10.0, 80.0) + (TIME))) * 10000.0);

	// apply noise
	color += noise_2 / (vignette * 2.2);

	// apply vignette
	color *= vignette * 1.5;

	// Screen flicker
	color += flicker * cos(sin(TIME * 120.0));

	// Final output
    // `fragColor` is `COLOR` in Godot.
	COLOR = vec4(color);
}