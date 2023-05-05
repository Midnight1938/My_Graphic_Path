#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

float createRectangle(vec2 position, vec2 scale){
    scale = vec2(0.5) - scale * 0.5; // Makes the scale go from 0 to 1 instead of -1 to 1
    vec2 shaper = vec2(step(scale.x, position.x), step(scale.y, position.y)); // Makes the top and right side of the rectangle
    shaper *= vec2(step(scale.x, 1.0-position.x),  step(scale.y, 1.0-position.y)); // scales 
    return shaper.x * shaper.y;
}

void main(){
    vec2 position = gl_FragCoord.xy/u_resolution;
    
    vec3 colour = vec3(0.0);

    float rectangle = createRectangle(position, vec2(0.4,0.4));
    colour = vec3(rectangle);
    gl_FragColor = vec4(colour, 1.0);
}