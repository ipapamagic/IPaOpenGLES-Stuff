//
//  IPaGLWavefrontObjRenderer.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/18.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "IPaGLWavefrontObjRenderer.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
#import "IPaGLWavefrontObj.h"
@implementation IPaGLWavefrontObjRenderer
{
    GLint modelViewProjectionMatrixUniform;
    GLint normalMatrixUniform;
    GLint diffuseColorUniform;
    GLint textRatioUniform;
}
-(NSString*)vertexShaderSource
{
    return @"attribute vec4 position;\
        attribute vec3 normal;\
        varying lowp vec4 colorVarying;\
        uniform mat4 modelViewProjectionMatrix;\
        uniform mat3 normalMatrix;\
        uniform vec3 diffuseColor;\
        attribute vec2 texCoord;\
        uniform vec2 textRatio;\
        varying lowp vec2 v_texCoord;\
        void main()\
        {\
            vec3 eyeNormal = normalize(normalMatrix * normal);\
            vec3 lightPosition = vec3(0.0, 0.0, 1.0);\
            float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));\
            colorVarying.xyz = diffuseColor * nDotVP;\
            v_texCoord = textRatio * texCoord;\
            gl_Position = modelViewProjectionMatrix * position;\
        }";
}
-(NSString*)fragmentShaderSource
{
    return @"varying lowp vec4 colorVarying;\
        varying lowp vec2 v_texCoord;\
        uniform sampler2D texture;\
        void main()\
        {\
            gl_FragColor = texture2D(texture, v_texCoord);\
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
    normalMatrixUniform = glGetUniformLocation(_program, "normalMatrix");
    diffuseColorUniform = glGetUniformLocation(_program,"diffuseColor");
    textRatioUniform = glGetUniformLocation(_program,"textRatio");
}

- (void)prepareToRenderWavefrontOject:(IPaGLWavefrontObj*)wavefrontObj
{
    glUniformMatrix4fv(modelViewProjectionMatrixUniform, 1, 0, self.modelViewProjectionMatrix.m);
    glUniformMatrix3fv(normalMatrixUniform, 1, 0, self.normalMatrix.m);
}
-(void)prepareToRenderWithMaterial:(IPaGLMaterial *)material
{
    [material bindTexture];
    if (material.diffuse != nil) {
        CGFloat r,g,b,a;
        [material.diffuse getRed:&r green:&g blue:&b alpha:&a];
        glUniform3f(diffuseColorUniform, r, g, b);
        
    }
    else {
        glUniform3f(diffuseColorUniform, 0, 0, 0);
    }
    if (material.texture != nil) {
        glUniform2f(textRatioUniform, material.texture.texCoordRatio.x, material.texture.texCoordRatio.y);
        
    }
}

@end
