#ifdef GL_ES
precision mediump float;
#endif

void main(){
    vec3 colour = vec3(0.6, 0.4, 0.9);
    gl_FragColor = vec4(colour, 1.0);
}