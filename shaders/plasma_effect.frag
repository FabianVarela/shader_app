#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec2 iResolution;

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 I = fragCoord;
    vec4 O = vec4(0.0);

    vec2 r = iResolution.xy;
    float padding = 1.5;

    vec2 p = ((I+I-r) / r.y) * padding;
    vec2 z = vec2(0.0);

    z += 4.0 - 4.0 * abs(0.7 - dot(p, p));
    vec2 f = p * z;

    O = vec4(0.0);
    vec2 i = vec2(0.0, 0.0);

    for (int j = 0; j < 8; j++) {
        i.y = float(j);
        f += cos(f.yx * i.y + i + iTime) / vec2(i.y + 1.0) + 0.7;
        O += (sin(f) + vec2(1.0)).xyyx * abs(f.x - f.y);
    }

    O = tanh(7.0 * exp(z.x - 4.0 - p.y * vec4(-1.0, 1.0, 2.0, 0.0)) / O);
    fragColor = O;
}