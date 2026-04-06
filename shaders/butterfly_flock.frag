#include <flutter/runtime_effect.glsl>

precision highp float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec4 u_mouse;
uniform sampler2D u_noise;
uniform sampler2D u_env;

out vec4 fragColor;

mat3 rotx(float a) {
    mat3 rot;
    rot[0] = vec3(1.0, 0.0, 0.0);
    rot[1] = vec3(0.0, cos(a), -sin(a));
    rot[2] = vec3(0.0, sin(a), cos(a));
    return rot;
}

mat3 roty(float a) {
    mat3 rot;
    rot[0] = vec3(cos(a), 0.0, sin(a));
    rot[1] = vec3(0.0, 1.0, 0.0);
    rot[2] = vec3(-sin(a), 0.0, cos(a));
    return rot;
}

mat3 rotz(float a) {
    mat3 rot;
    rot[0] = vec3(cos(a), -sin(a), 0.0);
    rot[1] = vec3(sin(a), cos(a), 0.0);
    rot[2] = vec3(0.0, 0.0, 1.0);
    return rot;
}

const float mouseRotateSpeed = 5.0;

vec4 sampleEnv(vec3 dir) {
    vec3 d = normalize(dir);
    d.y = -d.y;

    float u = atan(d.z, d.x) / (2.0 * 3.14159265) + 0.5;
    float v = asin(clamp(d.y, -1.0, 1.0)) / 3.14159265 + 0.5;

    return texture(u_env, vec2(u, 1.0 - v));
}

struct sdObject {
    vec3 pos;
    float rad;
    int index;
};

#define OBJECTS 40
#define CACHED  5

sdObject sdObjects[OBJECTS];
sdObject cachedObjects[CACHED];

int maxCacheIndex = 0;

float udBox(vec3 p, vec3 b) {
    return length(max(abs(p) - b, 0.0));
}

float sdHexPrism(vec3 p, vec2 h) {
    vec3 q = abs(p);
    return max(q.z - h.y, max((q.x * 0.866025 + q.y * 0.5), q.y) - h.x);
}

const float MATERIAL_BODY = 0.0;
const float MATERIAL_WING = 1.0;
const float OBJECT_SIZE = 0.5;

vec2 getModel(in vec3 pos, int index) {
    float phase = float(index);
    float l = length(pos);

    float bl = (sin(pos.z * 12.0 - 5.0) * 0.5 + 0.5) + 0.3;
    float body = sdHexPrism(
        pos - vec3(0.0, 0.0, 0.0),
        vec2(OBJECT_SIZE * 0.04 * bl, OBJECT_SIZE * 0.2)
    );

    float wx = max(abs(l * 6.0 + 0.2) - 0.4, 0.0);
    float sl = 1.5 * abs(sin(wx)) + 0.05;

    vec3 wing = vec3(OBJECT_SIZE * 0.5, OBJECT_SIZE * 0.01, OBJECT_SIZE * 0.25 * sl);
    float w1 = udBox(
        rotz(sin(u_time * 22.0 + phase)) * pos - vec3(OBJECT_SIZE * 0.5, OBJECT_SIZE * 0.0, 0.0),
        wing
    );
    float w2 = udBox(
        rotz(-sin(u_time * 22.0 + phase)) * pos + vec3(OBJECT_SIZE * 0.5, OBJECT_SIZE * 0.0, 0.0),
        wing
    );

    float id = MATERIAL_BODY;
    if (w1 < body || w2 < body) {
        id = MATERIAL_WING;
    }

    float m = min(body, min(w1, w2));
    return vec2(m, id);
}

vec2 map(in vec3 rp, inout vec3 localPos, inout int index) {
    float m = 9999.0;
    vec2 ret = vec2(m, 0.0);

    for (int i = 0; i < CACHED; ++i) {
        if (i <= maxCacheIndex) {
            vec3 lp = rp - cachedObjects[i].pos;
            vec2 mat = getModel(lp, cachedObjects[i].index);

            if (mat.x < m) {
                m = mat.x;
                ret = mat;
                localPos = lp;
                index = cachedObjects[i].index;
            }
        }
    }
    return ret;
}

float prestep(in vec3 ro, in vec3 rp, in vec3 rd, in vec3 rd90X, in vec3 rd90Y) {
    maxCacheIndex = -1;
    float m = 99999.0;

    for (int i = 0; i < OBJECTS; ++i) {
        vec3 sp = -ro + sdObjects[i].pos;

        float distToPlaneY = abs(dot(rd90Y, sp));
        float distToPlaneX = abs(dot(rd90X, sp));
        float distToPlanes = max(distToPlaneY, distToPlaneX) - sdObjects[i].rad;

        vec2 mat = getModel(
            rp - sdObjects[i].pos * (1.0 + distToPlanes),
            sdObjects[i].index
        );
        m = min(m, mat.x);

        if (distToPlanes <= 0.0 && ++maxCacheIndex < CACHED) {
            if (maxCacheIndex == 0) cachedObjects[0] = sdObjects[i];
            else if (maxCacheIndex == 1) cachedObjects[1] = sdObjects[i];
            else if (maxCacheIndex == 2) cachedObjects[2] = sdObjects[i];
            else if (maxCacheIndex == 3) cachedObjects[3] = sdObjects[i];
            else if (maxCacheIndex == 4) cachedObjects[4] = sdObjects[i];
            else return m;
        }
    }
    return m;
}

void trace(in vec3 rp, in vec3 rd, inout vec4 color) {
    vec3 ro = rp;
    float travel = 0.0;
    const int STEPS = 50;

    vec3 tmp = normalize(cross(rd, vec3(0.0, 1.0, 0.0)));
    vec3 up = normalize(cross(rd, tmp));
    vec3 right = cross(rd, up);

    travel = prestep(ro, rp, rd, right, up);
    rp += travel * rd;

    vec3 local = vec3(0.0);
    int hitindex = 0;

    for (int i = 0; i < STEPS; ++i) {
        vec2 mat = map(rp, local, hitindex);
        float dist = mat.x;

        if (dist <= 0.0) {
            float indx = float(hitindex);
            float c1 = sin(indx * 0.1) * 0.5 + 0.5;
            float c2 = abs(cos(abs(local.z * 15.0)) + sin(abs(local.x) * 15.0));

            color = vec4(mat.y, c2 * mat.y, c1 * mat.y, 1.0) * abs(sin(indx * 0.1));
            color.a = 1.0;

            return;
        }

        float dst = max(0.01, dist);
        travel += dst;
        rp += rd * dst;

        if (travel > 30.0) return;
    }
}

void main() {
    fragColor = vec4(0.0);

    vec2 fc = FlutterFragCoord().xy;
    vec2 uv = fc / u_resolution.xy;

    uv -= vec2(0.5);
    uv.y /= u_resolution.x / u_resolution.y;

    vec2 mouse = u_mouse.xy / u_resolution.xy;
    mouse -= vec2(0.5);

    if (mouse.xy == vec2(-0.5)) mouse = vec2(0.0);
    mouse *= mouseRotateSpeed;

    for (int i = 0; i < OBJECTS; ++i) {
        vec3 p = (texture(u_noise, sin(u_time * 0.001) + 0.21 * vec2(float(i))) - vec4(0.5)).rgb;

        p *= roty(u_time * 2.0);
        p.z += (sin(u_time) * 0.5 + 0.5) * 1.0;
        p.x *= 1.0 + (sin(u_time * 0.1) * 0.5 + 0.5) * 0.25;
        p.y *= 1.0 + (cos(u_time * 0.1) * 0.5 + 0.5) * 0.25;

        sdObjects[i] = sdObject(p * 10.0, OBJECT_SIZE * 1.0, i);
    }

    vec3 rp = vec3(0.0, 0.0, 1.0);
    float fov = u_resolution.x < u_resolution.y ? 0.18 : 0.3;
    vec3 rd = normalize(vec3(uv, fov));

    rd *= rotx(mouse.y);
    rd *= roty(mouse.x);

    trace(rp, rd, fragColor);

    vec3 envDir = rd * roty(3.14159 * 0.5);
    fragColor = mix(fragColor, sampleEnv(envDir), 1.0 - fragColor.a);

    float luma = (fragColor.r + fragColor.g + fragColor.b) * 0.33;
    fragColor -= luma * vec4(0.9, 0.5, 0.0, 1.0) * clamp(rd.y - 0.05, 0.0, 1.0);
    fragColor += vec4(0.2, 0.4, 0.0, 0.0) * abs(clamp(rd.y, -1.0, 0.0));

    fragColor = mix(fragColor, vec4(0.0), 1.0 - smoothstep(0.52, 0.48, abs(uv.x)));
    fragColor = mix(fragColor, vec4(0.0), 1.0 - smoothstep(0.52, 0.48, abs(uv.y)));
}
