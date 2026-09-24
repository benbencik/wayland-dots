#version 300 es
// Static glitch shader for hyprlock (applied via Hyprland screen_shader).
// RGB channel split, per-band horizontal displacement, scanlines.
// Deterministic: no time uniform, renders correctly on a locked screen.
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

void main() {
    vec2 uv = v_texcoord;

    // Split screen into horizontal bands; shove some sideways.
    float bands = 48.0;
    float band  = floor(uv.y * bands);
    float r     = hash(band);
    // Only some bands glitch; the rest stay put.
    float g     = step(0.70, r);
    float shift = (hash(band + 3.1) - 0.5) * 0.06 * g;
    uv.x += shift;

    // Chromatic aberration: offset red and blue channels apart.
    float ab = 0.004 + 0.010 * g;
    float cr = texture(tex, uv + vec2( ab, 0.0)).r;
    float cg = texture(tex, uv).g;
    float cb = texture(tex, uv + vec2(-ab, 0.0)).b;
    vec3 col = vec3(cr, cg, cb);

    // Slight color blow-out: lift saturation and push highlights toward clipping.
    float lum = dot(col, vec3(0.299, 0.587, 0.114));
    col = mix(vec3(lum), col, 1.12);   // +12% saturation
    col *= 1.10;                        // gentle exposure lift -> mild highlight bloom

    // Scanlines.
    // float scan = 0.90 + 0.10 * sin(v_texcoord.y * 900.0);
    //col *= scan;

    // Subtle vertical vignette.
    float vig = smoothstep(0.0, 0.35, uv.y) * smoothstep(1.0, 0.65, uv.y);
    col *= mix(0.85, 1.0, vig);

    fragColor = vec4(col, 1.0);
}
