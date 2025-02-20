#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;
uniform sampler2D u_texture;

uniform float time;
uniform vec2 resolution;

float rand(vec2 c) {
    return fract(sin(dot(c, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec2 uv = v_texCoord;

    float wave = sin((uv.y + time * 0.2) * 25.0) * 0.001;
    uv.x += wave;

    float lineIndex = floor(gl_FragCoord.y / 4.0);
    float lineShift = (rand(vec2(lineIndex, time * 10.0)) - 0.5) * 0.002;
    uv.x += lineShift;

    vec2 uvR = uv + vec2(0.001, 0.0);
    vec2 uvB = uv - vec2(0.001, 0.0);

    float r = texture2D(u_texture, uvR).r;
    float g = texture2D(u_texture, uv ).g;
    float b = texture2D(u_texture, uvB).b;
    float a = texture2D(u_texture, uv ).a;

    float scan = sin(gl_FragCoord.y * 3.1415 * 1.0);
    float lineFactor = 0.92 + 0.08 * scan;

    float noise = rand(floor(gl_FragCoord.xy * 2.0 + time * 5.0)) - 0.5;
    r += noise * 0.01;
    g += noise * 0.01;
    b += noise * 0.01;

    r = clamp(r * lineFactor, 0.0, 1.0);
    g = clamp(g * lineFactor, 0.0, 1.0);
    b = clamp(b * lineFactor, 0.0, 1.0);

    gl_FragColor = vec4(r, g, b, a);
}
