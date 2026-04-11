#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uResolution;

out vec4 fragColor;

#define W   2.0
#define SC  180.0
#define SAT 0.50
#define TAU 6.28318530718

vec3 h2r(float h) {
    h = fract(h);
    return clamp(abs(fract(h + vec3(0.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0) - 1.0, 0.0, 1.0);
}

vec3 rot(vec3 p, float yp, float yp2, float xp, float xp2, float s) {
    float y1 = p.y * yp + p.z * yp2;
    float z1 = p.y * yp2 - p.z * yp;
    float x1 = p.x * xp + z1 * xp2;
    float z2 = p.x * xp2 - z1 * xp;
    return vec3(x1, y1, z2) * pow(2.0, z2 * s);
}

// Idéntica al original — recibe res como parámetro, N=80
vec3 ring(vec2 px, int r, float yp, float yp2, float xp, float xp2, float s, float sc, vec2 res) {
    float md = 1e9, bh = 0.0, bz = 0.0;
    for (int i = 0; i < 80; i++) {
        float fi = float(i);
        float a1 = fi / 80.0 * TAU;
        float a2 = (fi + 1.0) / 80.0 * TAU;
        vec3 A, B;
        if (r == 0) {
            A = vec3(cos(a1), sin(a1), 0.0);
            B = vec3(cos(a2), sin(a2), 0.0);
        } else if (r == 1) {
            A = vec3(0.0, cos(a1), sin(a1));
            B = vec3(0.0, cos(a2), sin(a2));
        } else {
            A = vec3(sin(a1), 0.0, cos(a1));
            B = vec3(sin(a2), 0.0, cos(a2));
        }
        vec3 rA = rot(A, yp, yp2, xp, xp2, s);
        vec3 rB = rot(B, yp, yp2, xp, xp2, s);
        vec2 pa = rA.xy * sc + res * 0.5;
        vec2 pb = rB.xy * sc + res * 0.5;
        vec2 ab = pb - pa;
        float t = clamp(dot(px - pa, ab) / max(dot(ab, ab), 0.0001), 0.0, 1.0);
        float d = length(px - (pa + t * ab));
        if (d < md) {
            md = d;
            bh = (fi + t) / 80.0;
            bz = mix(rA.z, rB.z, t);
        }
    }
    float db = 0.4 + 0.8 * clamp(bz, -1.0, 1.0);
    float w = W * (0.8 + db * 0.4);
    float g = exp(-md * md / (w * w)) * db;
    return mix(vec3(1.0), h2r(bh), SAT) * g * 0.5;
}

void main() {
    vec2 fc = FlutterFragCoord().xy;
    // Flutter Y=0 es arriba, Shadertoy Y=0 es abajo — flipear Y
    vec2 px = vec2(fc.x, uResolution.y - fc.y);
    vec2 res = uResolution;

    vec3 col = vec3(0.0);
    float b = uTime * 12.0;

    float t0 = b * 1.7, s0 = 1.0;
    float t1 = b * 2.89, s1 = 0.6667;
    float t2 = b * 4.913, s2 = 0.3333;

    float yp0 = cos(t0 / 59.0), yp20 = sin(t0 / 59.0), xp0 = cos(t0 / 23.0), xp20 = sin(t0 / 23.0);
    float yp1 = cos(t1 / 59.0), yp21 = sin(t1 / 59.0), xp1 = cos(t1 / 23.0), xp21 = sin(t1 / 23.0);
    float yp2 = cos(t2 / 59.0), yp22 = sin(t2 / 59.0), xp2 = cos(t2 / 23.0), xp22 = sin(t2 / 23.0);

    for (int r = 0; r < 3; r++) {
        col += ring(px, r, yp0, yp20, xp0, xp20, s0, s0 * SC, res);
        col += ring(px, r, yp1, yp21, xp1, xp21, s1, s1 * SC, res);
        col += ring(px, r, yp2, yp22, xp2, xp22, s2, s2 * SC, res);
    }

    vec2 cv = px - res * 0.5;
    float d2 = dot(cv, cv);
    col += vec3(exp(-d2 / 55.0) * 4.0 + exp(-d2 / 500.0) * 0.5);

    col = 1.0 - exp(-col * 1.5);
    fragColor = vec4(col, 1.0);
}
