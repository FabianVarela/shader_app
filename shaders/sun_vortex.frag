#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec2 iResolution;

out vec4 fragColor;

#define R(a) mat2(cos(a + vec4(0, 33, 11, 0)))

vec3 palette(float i) {
    const vec3 a = vec3(0.50, 0.38, 0.26);
    const vec3 b = vec3(0.50, 0.35, 0.25);

    const vec3 c = vec3(1.00);
    const vec3 d = vec3(0.00, 0.12, 0.25);

    return a + b * cos(6.2831853 * (c * i + d));
}

vec3 palette2(float i) {
    const vec3 a = vec3(0.742702, 0.908877, 0.959831);
    const vec3 b = vec3(-0.711000, 0.275000, -0.052000);

    const vec3 c = vec3(1.000000, 1.855000, 1.000000);
    const vec3 d = vec3(0.180000, 0.091000, 0.380000);

    return a + b * cos(6.2831853 * (c * i + d));
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 u = fragCoord.xy;

    vec2 uv = (u - 0.5 * iResolution.xy + 0.5) / iResolution.y;

    float i = 0.0;
    float s = 0.0;
    float t = mod(iTime, 6.283185);

    vec3 p = vec3(0.0);

    vec3 res = vec3(2.0 * u - iResolution.xy, iResolution.y);
    vec3 d = normalize(res);

    p.z = t;
    fragColor = vec4(0.0);

    for (fragColor *= i; i < 20.0; i++) {
        p.xy *= R(- p.z * 0.01 - t * 0.05);

        s = 0.6;
        s = max(s, 4.0 * (-length(p.xy) + 10.0));
        s += abs(
            p.y * 0.004 +
            sin(t - p.x * 0.5) * 0.9 +
            1.0
        );

        p += d * s;
        fragColor += 1.0 / (s * 0.2);
    }

    fragColor *= vec4(palette(length(p) / (abs(sin(iTime * 0.02)) * 50.0 + 6.0)), 1.0);

    fragColor -= 20.0 *
    smoothstep(
        0.001,
        abs(sin(iTime * 5.0)),
        0.7 - length(sin(uv * 200.0) / 1.5) - abs(uv.y) + 0.2
    );
    fragColor /= 0.5e2;

    float l = length(uv);
    fragColor *= 1.2 - l;

    fragColor = mix(fragColor, palette(l - 0.23).rgbr, 1.0 - smoothstep(0.01, 0.95, l));
    fragColor = tanh(fragColor + fragColor);
}