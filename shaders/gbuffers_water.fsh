#version 130

uniform sampler2D texture;
uniform int worldTime;
uniform sampler2D noisetex;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;

varying vec4 texcoord;
varying vec4 color;
varying float blockID;
varying vec3 skyColor;
varying vec3 normal;
varying vec4 position;

const int noiseTextureResolution = 128;

// Complex Noise Activator
vec3 getWave(vec3 color, vec4 worldPosition) {
    //noise 1
    float speed = frameTimeCounter / (noiseTextureResolution * 15);
    vec3 coord = worldPosition.xyz / noiseTextureResolution;
    coord.x *= 3;
    coord.x += speed;
    coord.z += speed * 0.2;
    float noise = texture2D(noisetex, coord.xz).x;

    speed = frameTimeCounter / (noiseTextureResolution * 7);
    coord = worldPosition.xyz / noiseTextureResolution;
    coord.x *= 0.5;
    coord.x -= speed * 0.15 + noise * 0.05;
    coord.z -= speed * 0.7 - noise * 0.05;
    float noise2 = texture2D(noisetex, coord.xz).x;

    color *= noise2 * 0.6 + 0.4;

    return color;
}

void main() {
    vec4 worldPosition = gbufferModelViewInverse * position;
    worldPosition.xyz += cameraPosition;

    vec3 finalColor = skyColor;
    finalColor = getWave(skyColor, worldPosition);

    // Schlick fuctions
    float cosine = abs(dot(normalize(position.xyz), normalize(normal)));
    // cosine = clamp(abs(cosine), 0, 1);
    float factor = pow(1.0 - cosine, 4) + 0.05;

    gl_FragData[0] = vec4(mix(skyColor * 0.3, finalColor, factor), 0.75);

}