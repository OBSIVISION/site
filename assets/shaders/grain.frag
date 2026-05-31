#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
out vec4 fragColor;

float random(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    // Generate noise based on coordinates and time
    float noise = random(uv + fract(uTime));
    
    // Adjust 0.05 to change grain intensity
    float grain = noise * 0.05; 
    
    fragColor = vec4(vec3(grain), grain); 
}