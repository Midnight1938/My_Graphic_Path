
float sdSphere(vec3 pos, float radius) { return length(pos) - radius; }
float sdBox(vec3 pos, vec3 b){
    vec3 d = abs(pos) - b;
    return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, 0.0));
}
// float sdOctahedron(p, .15){
float sdOctahedron(vec3 p, float s) {
  p = abs(p);
  // return length(vec3(p.x + p.y )); happy accident
  return (p.x+p.y +p.z -s) * 0.57735027;
}

float smin(float a, float b, float k) {
  float h = clamp(.5 + .5 * (b - a) / k, 0., 1.);
  return mix(b, a, h) - k * h * (1. - h);
}

mat2 rot2D(float angle){
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

vec3 palette( float t ) {
    vec3 a = vec3(0.8, 0.5, 0.4);
    vec3 b = vec3(0.2, 0.4, 0.2);
    vec3 c = vec3(2.0, 1.0, 1.0);
    vec3 d = vec3(0.00, 0.25, 0.25);
    return a + b*cos( 4.28318*(c*t+d) );
}

float map(vec3 pos) { // Map of the space
  pos.z += iTime * .7; // Upward before repeting

  // Space Repition
  pos.xy = (fract(pos.xy) - .5); // .5 spacing. Fract is what makes the one thing infinite
  pos.z = mod(pos.z, .25) - .199; // .125 spacing. Makes it a lil diamond-y

  pos.xy *= rot2D(iTime); // Rotating around Z. 
  float box = sdOctahedron(pos, .15); // Octahedron
  
  // Closest dist to scene. With minimum distance function
  return box; // Smooth dist
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = (fragCoord * 2. - iResolution.xy) / iResolution.y; // uv means the pixel we are on. Ranges from -1 to 1
  vec2 mous = (iMouse.xy *2. - iResolution.xy) / iResolution.y;

  // Just imagine the space already exists.
  vec3 rayOrigin = vec3(0, 0, -3); // Ray Origin, camera position. Move like a cam
  vec3 rayDirec = normalize(vec3(uv * 1.5, 1)); // Camera Direction. Change FOV here
                                    // Normalization scales it so that all vecs
                                    // have a length of 1. For accurate Calc

  vec3 cllr = vec3(0); // Final Pixel

  float totalDist = 0.; // Total distance travelled
  /* // Camera Rotation
  // Vertical. Must come first to avoid gimbal lock
  rayOrigin.yz *= rot2D(-mous.y);
  rayDirec.yz *= rot2D(-mous.y);
  // Horizontal
  rayOrigin.xz *= rot2D(-mous.x);
  rayDirec.xz *= rot2D(-mous.x);
  */

  // Default Movement without Mouse
  if (iMouse.z<0.) mous = vec2(cos(iTime*.2), sin(iTime*.2))*.5; 

  // RayMarching
  int i;
  for (i = 0; i < 80; i++) { // 100 steps
    vec3 pos = rayOrigin + rayDirec * totalDist;        // Position Along Ray
    pos.xy *= rot2D(totalDist*.2 * mous.x); // Rotating around Z.

    pos.y += sin(totalDist*(mous.y+1.)*.5)*.45;
    float dist = map(pos);            // Distance to closest object
    totalDist += dist;                      // Add distance to total distance travelled

    // cllr = vec3(i) / 80.;

    if (dist < .0001 || totalDist > 1000.)
      break; // stop if distance from threshold is too little or too far
  }

  cllr = palette(totalDist*.04 + float(i)*.005); // Color based on distance travelled

  fragColor = vec4(cllr, 1);
}

/*
! Old Map
float map(vec3 pos) { // Map of the space
  vec3 spherePos = vec3(sin(iTime) * 3., 0, 0);
  float sphere = sdSphere(pos - spherePos, 1.); // Moving Sphere

  vec3 q = pos; // Copy
  q.y -= iTime * .7; // Upward before repeting

  q = fract(q) - .5;

  q.xy *= rot2D(iTime); // Rotating around Z. 
  float box = sdBox(q, vec3(.1)); // The division counteracts scaling factor

  float ground = pos.y + .75; // Ground
  
  // Closest dist to scene. With minimum distance function
  return smin(ground, smin(sphere, box, 1.5), .5); // Smooth dist
}
*/