#ifdef GL_ES
precision mediump float;
#endif

const float PI = 3.14159265;

uniform vec2 u_resolution;

float polygonShape(vec2 position, float radius, float sides) {
  position = position * 2.0 - 1.0; // 2.0 changes the position from top, and 1.0 from the bottom
  float angle = atan(position.x, position.y);
  float slice = PI * 2.0 / sides; // 2.0 makes the sides
  return step(radius, cos(floor(0.5 + angle / slice) * slice - angle) *
                          length(position)); // Formula for a polygon
}

void main() {

  vec2 position = (gl_FragCoord.xy / u_resolution.xy);

  vec3 colour = vec3(0.0);

  float polygon = polygonShape(position, 0.5, 5.8); // 5.8 makes it fun, 0.5 is the sizer

  colour = vec3(polygon);
  gl_FragColor = vec4(colour, 1.0);
}