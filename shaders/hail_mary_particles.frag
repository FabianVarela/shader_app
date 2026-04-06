#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform float u_speed;
uniform float u_density;
uniform float u_psize;
uniform float u_spread;
uniform float u_pbright;
uniform float u_nbright;
uniform float u_nscale;
uniform float u_vig;
out vec4 fragColor;

float hash21(vec2 p) {
    p = fract(p * vec2(234.34, 435.345));p += dot(p, p + 34.23);return fract(p.x * p.y);
}

vec2 hash22(vec2 p) {
    return vec2(hash21(p), hash21(p + 43.7));
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

vec3 nebula(vec2 uv) {
    vec2 p = uv * u_nscale;
    vec2 q = vec2(fbm(p + vec2(0.0, 0.0)), fbm(p + vec2(5.2, 1.3)));
    vec2 r = vec2(fbm(p + 4.0 * q + vec2(1.7, 9.2)), fbm(p + 4.0 * q + vec2(8.3, 2.8)));

    float f = clamp(fbm(p + 3.5 * r) * 1.4 - 0.15, 0.0, 1.0);
    vec3 c0 = vec3(0.28, 0.05, 0.07);
    vec3 c1 = vec3(0.62, 0.14, 0.16);

    vec3 c2 = vec3(0.82, 0.36, 0.33);
    vec3 c3 = vec3(0.95, 0.72, 0.70);
    vec3 col = c0;

    col = mix(col, c1, smoothstep(0.00, 0.35, f));
    col = mix(col, c2, smoothstep(0.30, 0.65, f));
    col = mix(col, c3, smoothstep(0.58, 1.00, f));

    return col * u_nbright;
}

float particleLayer(vec2 uvC, float scale, float layer) {
    vec2 p = uvC * scale, cell = floor(p), local = fract(p) - 0.5;
    vec2 seed = cell + layer * 17.39;
    vec2 jit0 = (hash22(seed) - 0.5) * 0.7;

    float zOff = hash21(seed + 2.0);
    float zSpeed = 0.5 + hash21(seed + 9.0) * 0.8;
    float z = fract(zOff + u_time * u_speed * zSpeed);

    vec2 cCenter = (cell + 0.5) / scale + jit0 / scale;
    vec2 radDir = normalize(cCenter + 0.001);
    vec2 jit = jit0 + radDir * z * z * u_spread;

    float sz = (0.02 + z * z * 0.07) * u_psize;
    float fade = smoothstep(0.0, 0.1, z) * smoothstep(1.0, 0.75, z);
    float bright = (0.4 + hash21(seed + 3.0) * 0.6) * fade;

    float d = length(local - jit);
    float core = smoothstep(sz, sz * 0.2, d) * bright;
    float halo = smoothstep(sz * 3.0, 0.0, d) * bright * 0.2;

    return clamp(core + halo, 0.0, 1.0);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / u_resolution;
    uv.x *= u_resolution.x / u_resolution.y;

    vec2 uvC = uv - vec2(u_resolution.x / u_resolution.y, 1.0) * 0.5;
    vec3 col = nebula(uv);

    float p1 = particleLayer(uvC, u_density * 1.00, 0.0);
    float p2 = particleLayer(uvC, u_density * 0.55, 1.0);
    float p3 = particleLayer(uvC, u_density * 0.25, 2.0);

    vec3 pw = vec3(1.0, 0.88, 0.88);

    col += pw * p1 * u_pbright * 0.65;
    col += mix(pw, vec3(1.0), 0.5) * p2 * u_pbright * 0.82;
    col += vec3(1.0) * p3 * u_pbright;

    vec2 vUV = uv / vec2(u_resolution.x / u_resolution.y, 1.0);

    col *= clamp(1.0 - dot(vUV - 0.5, vUV - 0.5) * u_vig, 0.0, 1.0);
    col = pow(clamp(col, 0.0, 1.0), vec3(0.4545));

    fragColor = vec4(col, 1.0);
}