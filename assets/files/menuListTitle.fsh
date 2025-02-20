#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;
uniform sampler2D u_texture;

uniform float time;

float rand(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = v_texCoord;

    float maxOffset = 0.005;
    float glitch = (rand(floor(uv * 50.0) + time) - 0.5) * maxOffset;
    uv.x += glitch;

    float r = texture2D(u_texture, uv + vec2(0.001, 0.0)).r;
    float g = texture2D(u_texture, uv).g;
    float b = texture2D(u_texture, uv - vec2(0.001, 0.0)).b;
    float a = texture2D(u_texture, uv).a;

    gl_FragColor = vec4(r, g, b, a);
}