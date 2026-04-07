#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uResolution;

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = (2. * fragCoord - uResolution.xy) / uResolution.y;

    vec3 color = vec3(0);
    float focal = 2.;

    vec3 ro = vec3(0, 0, 5);
    vec3 rd = normalize(vec3(uv, -focal));

    float T = uTime;

    float c = cos(T * .2), s = sin(T * .2);
    mat2 R = mat2(c, s, -s, c);

    ro.xz *= R;
    rd.xz *= R;
    ro.yx *= R;
    rd.yx *= R;

    float golden = .5 + .5 * sqrt(5.);
    vec2 aspect = vec2(1, golden);

    float t = 0.;
    float numsteps = 99.;
    float rcp_numsteps = 1. / numsteps;

    for (float i = 0.; i < numsteps && t < 1e3; i++) {
        vec3 p = rd * t + ro;
        vec3 q = p;

        float scale = log2(1. + length(p));
        float fadein1 = min(T, 10.) / 10.;

        float fadein2 = min(max(T - 10., 0.), 20.) / 20.;
        float fadein3 = min(max(T - 20., 0.), 30.) / 30.;

        scale *= .5 / (1. + fadein2 * 5.) * mix(1., dot(p, p) + 1., fadein3);

        c = cos(T), s = sin(T);
        R = mat2(c, s, -s, c);

        p /= scale;

        p = mix(p, abs(p) - 5., fadein1);
        p = mix(p, abs(p) - 2.5, fadein2);
        p = mix(p, abs(p) - 1., fadein3);

        p.xz *= R;
        p.yx *= R;

        float sdf = length(vec3(p.y, p.xz - clamp(p.xz, -aspect, aspect)));

        sdf = max(sdf, (length(q)) - 5.0);
        sdf = max(sdf, (length(p - vec3(0, 0, 4.5))) - 4.5);

        float dt = abs(sdf) * .2;
        t += dt * scale;

        float kernel = 1. / (.35 * dt + sdf * sdf);
        vec3 cmap = vec3(1, 2, 3);

        color += dt * kernel * (cmap * max(p.y / sdf, 0.) + vec3(4, 2, 1) * max(-p.y / sdf, 0.));
        T += sdf * .1;
    }

    color *= rcp_numsteps;
    color = 1. - exp(-pow(color, vec3(1.2)));
    color = pow(color, vec3(1. / 2.2));

    fragColor = vec4(color, 1);
}