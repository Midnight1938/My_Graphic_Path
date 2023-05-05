#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float circleShape(vec2 position, float radius){
    return step(radius, length(position - vec2(0.5)));
}

void main(){
    vec2 coord = gl_FragCoord.xy/u_resolution;
    vec3 colour = vec3(0.0);

    vec2 translate = vec2(sin(u_time/0.3), cos(u_time/0.6));
    coord += translate * 0.5;

    colour += vec3(circleShape(coord, 0.1));

    gl_FragColor = vec4(colour, 1.0);
}