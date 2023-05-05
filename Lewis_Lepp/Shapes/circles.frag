#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

float circleShape(vec2 position, float radius){
    return step(radius, length(position - vec2(0.5))); // 0.5 is subtracted to center the circle
}

void main(){
    vec2 position = gl_FragCoord.xy/u_resolution; // Normalized pixel coordinates

    vec3 colour = vec3(0.0);

    float circle = circleShape(position, 0.2);

    colour = vec3(circle);

    gl_FragColor = vec4(colour, 1.0);
}