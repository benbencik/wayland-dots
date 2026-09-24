#version 300 es
// Lowkey glitch shader for hyprlock (applied via Hyprland screen_shader).
// Video-compression look: macroblocking + color banding, no channel split.
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

    // Split screen into horizontal bands; only some glitch.
    float bands = 48.0;
    float band  = floor(uv.y * bands);
    float r     = hash(band);
    float g     = step(0.75, r);
    float shift = (hash(band + 3.1) - 0.5) * 0.02 * g;
    uv.x += shift;

    // Macroblocking: snap to a coarse pixel grid on glitching bands only.
    float blockSize = 20.0;
    vec2 blockUv = floor(uv * blockSize) / blockSize;
    uv = mix(uv, blockUv, g);

    vec3 col = texture(tex, uv).rgb;

    // Color-depth reduction -> low-bitrate banding.
    float levels = 24.0;
    col = floor(col * levels) / levels;

    // Subtle vertical vignette.
    float vig = smoothstep(0.0, 0.35, uv.y) * smoothstep(1.0, 0.65, uv.y);
    col *= mix(0.9, 1.0, vig);

    fragColor = vec4(col, 1.0);
}
