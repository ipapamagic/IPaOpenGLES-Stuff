attribute vec4 position;
attribute vec3 normal;
attribute vec2 texCoord;
uniform mat4 modelViewProjectionMatrix;
uniform vec3 lightPosition;
uniform vec3 eyePosition;
uniform float shininess;
uniform vec2 textRatio;
varying lowp vec2 v_texCoord;
varying lowp float diffuseLight;
varying lowp float specularLight;
varying highp float edge;
void main()
{
    v_texCoord = textRatio * texCoord;
    gl_Position = modelViewProjectionMatrix * position;
    vec3 N = normalize(normal);
    vec3 L = normalize(lightPosition - gl_Position.xyz);
    diffuseLight = max(dot(N,L),0.0);
    vec3 V = normalize(eyePosition - gl_Position.xyz);
    vec3 H = normalize(L+V);
    specularLight = pow(max(dot(N,H),0.0),shininess);
    if (diffuseLight <= 0.0)
        specularLight = 0.0;
    edge = max(dot(N,V),0.0);
}