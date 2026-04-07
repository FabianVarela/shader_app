#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uResolution;

out vec4 fragColor;

void main() {
    vec2 u = FlutterFragCoord().xy;
    vec3 p = vec3(uResolution, 1.0);

    vec2 uv = (u + u - p.xy) / p.y;
    vec3 D = normalize(vec3(uv, 0.4));

    mat2 r = mat2(cos(uTime / 4.0 + vec4(0.0, 33.0, 11.0, 0.0)));

    float i = 0.0, d = 0.0, s, t = uTime;
    vec4 o = vec4(0.0);

    for (int n = 0; n < 100; n++) {
        p = D * d;

        p.z -= 10.0;
        p.xz *= r;

        for (s = 0.01; s < 3.0; s += s) {
            p += cos(2.0 * t + p.yzx / 10.0) * 0.6;
            p -= abs(dot(sin(0.03 * p.z + t + p / s / 3.2), vec3(s)));
        }

        p.xy /= 4.0;
        s = 0.08 + 0.5 * abs(length(p) - 30.0);
        d += s;

        o += vec4(3.3, 2.0, 1.0, 0.0) / s * d + 10.0 * (1.0 + cos(i * 0.4 + vec4(2.0, 1.0, 0.0, 0.0))) / s;
        i += 1.0;
    }

    o = mix(o, o.zyxw, smoothstep(0.2, 1.0, length(uv) / 2.0));
    fragColor = tanh(0.2 + o * o / 9e8);
}
