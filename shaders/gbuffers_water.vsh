#version 130

attribute vec4 mc_Entity;

uniform int worldTime;
uniform float frameTimeCounter;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

varying vec4 texcoord;
varying vec4 color;
varying float blockID;
varying vec3 skyColor;
varying vec3 normal;
varying vec4 position;

vec4 getBump(vec4 position) {
    vec4 worldPosition = gbufferModelViewInverse * position;
    worldPosition.xyz += cameraPosition;

    worldPosition.y += sin(frameTimeCounter * 3.0 + worldPosition.z * 2) * 0.05;

    worldPosition.xyz -= cameraPosition;
    return gbufferModelView * worldPosition;
}

void main() {
    int hour = worldTime / 1000;
    int next = (hour + 1 < 24) ? (hour + 1) : 0;
    float delta = float(worldTime - hour * 1000) / 1000;

    position = gl_ModelViewMatrix * gl_Vertex;
    gl_Position = gbufferProjection * getBump(position);
    color = gl_Color;
    texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    blockID = mc_Entity.x;
    normal = gl_NormalMatrix * gl_Normal;
    vec3 skyColorNow, skyColorNext;

    if(hour <= 12)
        skyColorNow = vec3(0.1, 0.6, 0.9);
    else
        skyColorNow = vec3(0.02, 0.2, 0.27);

    if(next <= 12)
        skyColorNext = vec3(0.1, 0.6, 0.9);
    else
        skyColorNext = vec3(0.02, 0.2, 0.27);

    skyColor = mix(skyColorNow, skyColorNext, delta);
}