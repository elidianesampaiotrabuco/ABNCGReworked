#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;
uniform sampler2D u_texture;

uniform vec2 center;
uniform float radius;
uniform float strength; 

uniform float blurSize;

uniform float time;

vec2 swirlDistortion(vec2 uv, vec2 c, float r, float s) {
    vec2 offset = uv - c;
    float dist = length(offset);
    if (dist < r) {
        float percent = (r - dist) / r;
        float angle = s * percent * percent;
        float sinA = sin(angle);
        float cosA = cos(angle);
        offset = mat2(cosA, -sinA, sinA, cosA) * offset;
    }
    return c + offset;
}

void main() {
    float swirlTimeFactor = sin(time * 0.5) * 0.2;
    float swirlStrength = strength + swirlTimeFactor;

    vec2 baseUV = swirlDistortion(v_texCoord, center, radius, swirlStrength);

    vec4 sumColor = vec4(0.0);
    for (int j = -1; j <= 1; j++) {
        for (int i = -1; i <= 1; i++) {
            vec2 offset = vec2(float(i), float(j)) * blurSize;
            vec2 sampleUV = swirlDistortion(baseUV + offset, center, radius, swirlStrength);
            sumColor += texture2D(u_texture, sampleUV);
        }
    }

    sumColor /= 9.0;

    gl_FragColor = sumColor;
}
