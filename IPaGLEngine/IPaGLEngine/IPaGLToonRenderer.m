//
//  IPaGLToonRenderer.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/6/4.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLToonRenderer.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
@implementation IPaGLToonRenderer
{
    GLint modelViewProjectionMatrixUniform;
    GLint lightPositionUniform;
    GLint eyePositionUniform;
    GLint shininessUniform;
    GLint textRatioUniform;    
}
-(NSString*)vertexShaderSource
{
    return @"attribute vec4 position;\
            attribute vec3 normal;\
            attribute vec2 texCoord;\
            uniform mat4 modelViewProjectionMatrix;\
            uniform vec3 lightPosition;\
            uniform vec3 eyePosition;\
            uniform float shininess;\
            uniform vec2 textRatio;\
            varying lowp vec2 v_texCoord;\
            varying lowp float diffuseLight;\
            varying lowp float specularLight;\
            varying highp float edge;\
            void main()\
            {\
                v_texCoord = textRatio * texCoord;\
                gl_Position = modelViewProjectionMatrix * position;\
                vec3 N = normalize(normal);\
                vec3 L = normalize(lightPosition - gl_Position.xyz);\
                diffuseLight = max(dot(N,L),0.0);\
                vec3 V = normalize(eyePosition - gl_Position.xyz);\
                vec3 H = normalize(L+V);\
                specularLight = pow(max(dot(N,H),0.0),shininess);\
                if (diffuseLight <= 0.0)\
                    specularLight = 0.0;\
                edge = max(dot(N,V),0.0);\
            }";
}
-(NSString*)fragmentShaderSource
{
    return @"varying lowp vec2 v_texCoord;\
            varying lowp float diffuseLight;\
            varying lowp float specularLight;\
            varying highp float edge;\
            uniform sampler2D texture;\
            void main()\
            {\
                if  (edge < 0.2)\
                {\
                    gl_FragColor = vec4(0,0,0,1);\
                }\
                else {\
                    if (diffuseLight < 0.5)\
                    {\
                        gl_FragColor = vec4(0.3,0.3,0.3,1);\
                    }\
                    else if(diffuseLight >= 0.5 && diffuseLight < 0.85)\
                    {\
                        gl_FragColor = texture2D(texture, v_texCoord);\
                    }\
                    else\
                    {\
                        gl_FragColor = vec4(specularLight,specularLight,specularLight,1);\
                    }\
                }\
            }";

    //    gl_FragColor = colorVarying + texture2D(texture, v_texCoord);
}
-(void)onBindGLAttributes:(GLuint)_program
{
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoord");
    
}
-(void)onGetGLUniforms:(GLuint)_program
{
    modelViewProjectionMatrixUniform = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    lightPositionUniform = glGetUniformLocation(_program, "lightPosition");
    eyePositionUniform = glGetUniformLocation(_program,"eyePosition");
    textRatioUniform = glGetUniformLocation(_program,"textRatio");
    shininessUniform = glGetUniformLocation(_program,"shininess");
}
-(void)onBindGLUniforms
{
    glUniformMatrix4fv(modelViewProjectionMatrixUniform, 1, 0, self.modelViewProjectionMatrix.m);
    glUniform3f(lightPositionUniform, self.lightPosition.x, self.lightPosition.y, self.lightPosition.z);
    glUniform3f(eyePositionUniform, self.eyePosition.x, self.eyePosition.y, self.eyePosition.z);
    
    glUniform1f(shininessUniform, self.shininess);
    
}
-(void)prepareToRenderWithMaterial:(IPaGLMaterial *)material
{
    [super prepareToRenderWithMaterial:material];
   
    if (material.texture != nil) {
        glUniform2f(textRatioUniform, material.texture.texCoordRatio.x, material.texture.texCoordRatio.y);
        
    }
}

@end
