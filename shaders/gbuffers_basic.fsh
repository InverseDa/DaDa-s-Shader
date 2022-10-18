#version 120

varying vec4 color;

void main(){
    gl_FragColor[0] = color;
}