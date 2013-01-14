//
//  Shader.vsh
//  TestGL
//
//  Created by IPaPa on 13/1/8.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;

varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

attribute vec2 texCoord;
varying lowp vec2 v_texCoord; // Varying in vertex shader

void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(0.4, 0.4, 1.0, 1.0);
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    colorVarying = diffuseColor * nDotVP;
    

    v_texCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * position;
}
