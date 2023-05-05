#ifdef GL_ES
precision mediump float;
#endif

void main(){
    vec3 colour = vec3(0.8, 0.5, 0.9);
    gl_FragColor = vec4(colour,0.5);
}