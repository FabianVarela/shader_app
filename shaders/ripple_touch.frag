#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform vec2 iMouse;
uniform float iTime;
uniform sampler2D iChannel0;

const float amplitude = 0.05;
const float frequency = 10.0;
const float decay = 2.0;
const float speed = 1.0;

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;

    // Normalize the coordinates
    vec2 uv = fragCoord / iResolution.xy;

    // Get the cursor position and normalize it
    vec2 origin = iMouse.xy / iResolution.xy;

    // Calculate the distance from the origin
    float distance = length(uv - origin);
    // Calculate the delay based on the distance
    float delay = distance / speed;

    // Adjust the time for the delay and clamp to 0
    float time = iTime - delay;
    time = max(0.0, time);

    // Calculate the ripple amount
    float rippleAmount = amplitude * sin(frequency * time) * exp(-decay * time);

    // Calculate the normalized direction vector
    vec2 n = normalize(uv - origin);

    // Calculate the new position by adding the ripple effect
    vec2 newPosition = uv + rippleAmount * n;

    // Sample the texture at the new position
    vec3 color = texture(iChannel0, newPosition).rgb;

    // Lighten or darken the color based on the ripple amount
    color += 0.1 * (rippleAmount / amplitude);

    // Set the fragment color
    fragColor = vec4(color, 1.0);
}