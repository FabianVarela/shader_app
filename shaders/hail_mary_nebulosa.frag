#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform float u_speed;
uniform float u_scale;
uniform float u_warp2;
uniform float u_gbright;
uniform float u_orange;
uniform float u_magenta;
uniform float u_contrast;
uniform float u_vig;
out vec4 fragColor;

float hash21(vec2 p) {
    p = fract(p * vec2(234.34, 435.345));p += dot(p, p + 34.23);return fract(p.x * p.y);
}

float vnoise(vec2 p) {
    vec2 i = floor(p), f = fract(p), u = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(hash21(i), hash21(i + vec2(1, 0)), u.x),
        mix(hash21(i + vec2(0, 1)), hash21(i + vec2(1, 1)), u.x),
        u.y
    );
}
float fbm(vec2 p) {
    float v = 0.0, a = 0.5;
    mat2 m = mat2(1.6, 1.2, -1.2, 1.6);

    for (int i = 0;i < 6; i++) {
        v += a * vnoise(p);p = m * p;a *= 0.5;
    }
    return v;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / u_resolution;
    uv.x *= u_resolution.x / u_resolution.y;

    float t = u_time * u_speed;
    vec2 p = uv * u_scale;

    vec2 q = vec2(fbm(p + vec2(0.0, 0.0) + t), fbm(p + vec2(5.2, 1.3) + t));
    vec2 r = vec2(fbm(p + 4.0 * q + vec2(1.7, 9.2) + 0.15 * t),

    fbm(p + 4.0 * q + vec2(8.3, 2.8) + 0.126 * t));
    float f = clamp(pow(fbm(p + u_warp2 * r + 0.05 * t) * 1.35, u_contrast), 0.0, 1.0);

    vec3 col = vec3(0.01, 0.04, 0.01);
    col = mix(col, vec3(0.04, 0.18, 0.04), smoothstep(0.00, 0.30, f));
    col = mix(col, vec3(0.10, 0.55, 0.08), smoothstep(0.25, 0.58, f));
    col = mix(col, vec3(0.45, 0.95, 0.15), smoothstep(0.50, 1.00, f));
    col *= u_gbright;

    vec2 p2 = uv * u_scale * 0.8;
    vec2 q2 = vec2(fbm(p2 + vec2(12.5, 3.7) + t * 0.7), fbm(p2 + vec2(2.3, 8.1) + t * 0.7));

    float fo = clamp(pow(fbm(p2 + 3.0 * q2 + vec2(4.4, 1.2) + t * 0.5) * 1.2, 2.2), 0.0, 1.0);
    col = mix(col, col + vec3(0.75, 0.28, 0.04), fo * u_orange);

    float fm = clamp(pow(fbm(p * 1.3 + vec2(7.7, 14.3) + t * 0.3), 3.5), 0.0, 1.0);
    col = mix(col, col + vec3(0.85, 0.15, 0.55) * 0.6, fm * u_magenta);

    vec2 vUV = uv / vec2(u_resolution.x / u_resolution.y, 1.0);
    col *= clamp(1.0 - dot(vUV - 0.5, vUV - 0.5) * u_vig, 0.0, 1.0);
    col = pow(clamp(col, 0.0, 1.0), vec3(0.4545));

    fragColor = vec4(col, 1.0);
}