shader_type canvas_item;
uniform sampler2D NOISE_PATTERN;

void fragment(){
    float noiseValue = texture(NOISE_PATTERN, UV).x;
    COLOR = vec4(noiseValue);
}