// Author: Thomas Stehle
// Title: Sun Tracks
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
// Link: https://www.shadertoy.com/view/ftSGWt
// Inspired by this long exposure photograph by Martin Cann:
// https://twitter.com/MartinCann1/status/1408139994972278788

// Constants
const vec3 INNER = vec3(131, 118, 117) / 255.0;
const vec3 OUTER = vec3(  1,  34,  46) / 255.0;
const vec3 SUN   = vec3(224, 229, 180) / 255.0;
const vec3 GLOW  = vec3(247, 251, 238) / 255.0;

const int NLINES     = 100;
const float NLINES_F = float(NLINES);

// 1D hash for 1D input by David Hoskins
// https://www.shadertoy.com/view/4djSRW
float hash(in float p) {
    p = fract(p * 0.011);
    p *= p + 7.5;
    p *= p + p;
    return fract(p);
}

// 1D hash for 2D input by David Hoskins
// https://www.shadertoy.com/view/4djSRW
float hash21(in vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.13);
    p3 += dot(p3, p3.yzx + 3.333);
    return fract((p3.x + p3.y) * p3.z);
}

// 1D hash for 3D input
float hash31(in vec3 p) {
    vec3 q = fract(p * 0.1031);
    q += dot(q, q.yzx + 33.33);
    return fract((q.x + q.y) * q.z);
}

// 2D value noise by Morgan McGuire
// https://www.shadertoy.com/view/4dS3Wd
float vnoise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    // Four corners in 2D of a tile
    float a = hash21(i);
    float b = hash21(i + vec2(1.0, 0.0));
    float c = hash21(i + vec2(0.0, 1.0));
    float d = hash21(i + vec2(1.0, 1.0));

    // Smooth interpolation (smoothstep without clamping)
    vec2 u = f*f * (3.0 - 2.0*f);

    // Mix 4 coorners
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

// 2D Fractional Brownian motion based on value noise by Morgan McGuire
// https://www.shadertoy.com/view/4dS3Wd
float vfbm(in vec2 p) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    // Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));
    const int NOCTAVES = 5;
    for (int i = 0; i < NOCTAVES; ++i) {
        v += a * vnoise(p);
        p = rot * p * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

// OKLAB-based color mixing by iq
// https://www.shadertoy.com/view/ttcyRS
vec3 oklab_mix( vec3 colA, vec3 colB, float h ) {
    // https://bottosson.github.io/posts/oklab
    const mat3 kCONEtoLMS = mat3(
         0.4121656120,  0.2118591070,  0.0883097947,
         0.5362752080,  0.6807189584,  0.2818474174,
         0.0514575653,  0.1074065790,  0.6302613616);
    const mat3 kLMStoCONE = mat3(
         4.0767245293, -1.2681437731, -0.0041119885,
        -3.3072168827,  2.6093323231, -0.7034763098,
         0.2307590544, -0.3411344290,  1.7068625689);
    
    // rgb to cone (arg of pow can't be negative)
    vec3 lmsA = pow( kCONEtoLMS*colA, vec3(1.0/3.0) );
    vec3 lmsB = pow( kCONEtoLMS*colB, vec3(1.0/3.0) );
    
    // lerp
    vec3 lms = mix( lmsA, lmsB, h );
    
    // gain in the middle (no oaklab anymore, but looks better?)
    // lms *= 1.0+0.2*h*(1.0-h);
    
    // cone to rgb
    return kLMStoCONE*(lms*lms*lms);
}

float sdOrientedBox(in vec2 p, in vec2 a, in vec2 b, float th) {
    float l = length(b-a);
    vec2  d = (b-a)/l;
    vec2  q = (p-(a+b)*0.5);
          q = mat2(d.x,-d.y,d.y,d.x)*q;
          q = abs(q)-vec2(l,th)*0.5;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0);
}

vec2 distort(in vec2 p) {
    vec2 q = 0.8 * p + vec2(-0.2, 0.2);
    float amp = -0.4;
    float freq = 1.0 + 4.0 * q.y;
    float phase = 0.0;
    return vec2(q.x, q.y + amp * sin(freq * q.x + phase));
}

float suntracks(in vec2 p) {
    vec2 st = vec2(p.x, p.y * NLINES_F);
    st.y = max(st.y, 0.1 * NLINES_F);
    st.y = min(st.y, 0.55 * NLINES_F);
    
    vec2 gv = vec2(st.x, fract(st.y));
    float id = floor(st.y);
    int idx = int(id);
    
    float r1 = hash(13.1 * float(idx));
    float r2 = hash(37.3 * float(idx));
    
    float speed = 0.25 + 0.25 * r2;
    
    const float W = 0.25;
    float d = sdOrientedBox(gv, vec2(-1.0, 0.5), vec2(2.0, 0.5), W);
    float n = vfbm(vec2(30.0 * (gv.x + id) - speed * iTime, 0.0));
    d += 0.25 * r2 + smoothstep(0.55, 0.65, n);

    return d;
}

float foreground(in vec2 p) {
    vec2 q = vec2(p.x, p.y + 0.2 * vfbm(10.0 * p));
    const float W = 0.25;
    return sdOrientedBox(q, vec2(-1.0, 0.0), vec2(2.0, 0.0), W);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Coordinate normalization
    vec2 uv = fragCoord.xy / iResolution.xy;
    float ar = iResolution.x / iResolution.y;
    uv.x *= ar;

    // Background
    float bg = pow(10.0 * length(0.15 * uv - vec2(0.075, 0.1)), 1.5);
    vec3 col = oklab_mix(INNER, OUTER, clamp(bg, 0.0, 1.0));
    
    // Foreground
    float fgd = foreground(uv);
    fgd = smoothstep(0.15, 0.1, fgd);
    col = mix(col, vec3(0.05), fgd);
    
    // Distort
    vec2 p = distort(uv);
    
    // Fade out factors
    float fade = smoothstep(0.75, 0.25, length(p - vec2(0.5))); // Fade out to the sides
    
    // Sun tracks
    float td = suntracks(p);
    td  = smoothstep(0.5, -0.5, td) * fade;
    td *= smoothstep(0.05, 0.2, uv.y); // Additional fade out near bottom
    col = mix(col, SUN, clamp(td, 0.0, 1.0));
    
    // Gas tracks
    float n = vfbm(2.0 * p - vec2(0.15 * iTime, 0.0));
    n *= (1.0 - fgd);
    col = oklab_mix(col, SUN, pow(n, 3.0));
    
    // Glow
    float gl = vnoise(2.0 + sin(1.5 * iTime) * p);
    gl  = pow(gl, 2.0) * fade;
    gl *= smoothstep(0.7, 0.4, p.y) * smoothstep(-0.1, 0.2, p.y); // Additional fade in sun space
    gl *= smoothstep(0.05, 0.2, uv.y); // Additional fade in screen space
    col = mix(col, GLOW, clamp(gl, 0.0, 1.0));
    
    // Add animated noise
    float r = hash31(vec3(fragCoord.xy, fract(0.001 * iTime)));
    col.rgb += 0.1 * vec3(r - 0.5);
    
    // Vignetting
    // https://www.shadertoy.com/view/lsKSWR
    vec2 st = uv * (vec2(1.0, ar) - uv.yx);
    float vig = st.x * st.y * 10.0;
    col *= pow(vig, 0.2);
    
    // Final color
    fragColor = vec4(col, 1.0);
}
