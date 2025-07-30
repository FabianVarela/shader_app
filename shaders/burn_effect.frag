#include <flutter/runtime_effect.glsl>

#define ANIM_DURATION 2.5

uniform vec2 iResolution;
uniform float iTime;

uniform sampler2D sourceImage;
uniform sampler2D targetImage;

out vec4 fragColor;

bool isTextureEmpty(sampler2D tex, vec2 uv) {
    vec4 txt = texture(tex, uv);
    return txt.a == 0.0 && txt.rgb == vec3(0.0);
}

vec4 textureSource(sampler2D textureSampler, vec2 uv) {
    return texture(textureSampler, uv);
}

float hash(vec2 p) {
    vec3 p2 = vec3(p.xy, 1.0);
    return fract(sin(dot(p2, vec3(37.1, 61.7, 12.4))) * 3758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    f = f * (3.0 - 2.0 * f);

    float mo = mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), f.x);
    float mt = mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x);

    return mix(mo, mt, f.y);
}

float fbm(vec2 p) {
    float v = 0.0;

    v += noise(p * 1.0) * 0.5;
    v += noise(p * 2.0) * 0.25;
    v += noise(p * 4.0) * 0.125;

    return v;
}

void main() {
    vec2 fragCoord = FlutterFragCoord();
    vec2 uv = fragCoord / iResolution.xy;

    vec4 src = textureSource(sourceImage, uv);
    vec4 tgt = vec4(0.0);

    if (!isTextureEmpty(targetImage, uv)) {
        tgt = texture(targetImage, uv);
    }

    vec3 col = src.rgb;
    uv.x -= 1.5;

    float ctime = mod(iTime * 0.5, ANIM_DURATION);
    float d = uv.x + uv.y * 0.5 + 0.5 * fbm(uv * 15.1) + ctime * 1.3;

    if (d > 0.35) col = clamp(col - (d - 0.35) * 10.0, 0.0, 1.0);

    if (d > 0.47) {
        if (d < 0.5) {
            col += (d - 0.4) * 33.0 * 0.5 * (0.0 + noise(100.0 * uv + vec2(-ctime * 2.0, 0.0))) * vec3(1.5, 0.5, 0.0);
        } else {
            col += tgt.rgb;
        }
    }

    fragColor = vec4(col, 1.0);
}