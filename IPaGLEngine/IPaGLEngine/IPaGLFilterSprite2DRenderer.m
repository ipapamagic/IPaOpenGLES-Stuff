//
//  IPaGLFilterSprite2DRenderer.m
//  MrMagic
//
//  Created by IPaPa on 13/4/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLFilterSprite2DRenderer.h"

@implementation IPaGLFilterSprite2DRenderer
{
    GLint textureUniform;
    GLint brightnessUniform;
    GLint contrastUniform;
}

-(NSString*)vertexShaderSource
{
    return @"attribute vec4 position;\
            attribute vec2 texCoord;\
            varying lowp vec2 v_texCoord;\
            void main()\
            {\
                v_texCoord = texCoord;\
                gl_Position = position;\
            }";

}
-(NSString*)fragmentShaderSource
{
    return @"varying lowp vec2 v_texCoord;\
            uniform sampler2D texture;\
            uniform lowp float Brightness;\
            uniform lowp float Contrast;\
            void main(void)\
            {\
                lowp vec4 texColour = texture2D(texture, v_texCoord);\
                gl_FragColor = (texColour - 0.5) * max(Contrast,0.0) + 0.5;\
                gl_FragColor = gl_FragColor * Brightness;\
            }";
}

-(void)onBindGLAttributes:(GLuint)_program
{
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoord");
    
}
-(void)onGetGLUniforms:(GLuint)_program
{
    textureUniform = glGetUniformLocation(_program, "texture");
    brightnessUniform = glGetUniformLocation(_program, "Brightness");
    contrastUniform = glGetUniformLocation(_program, "Contrast");
}
-(void)onBindGLUniforms
{
    glUniform1f(brightnessUniform, self.brightness);
    glUniform1f(contrastUniform, self.contrast);
}

//-(void)prepareToRenderWithMaterial:(IPaGLMaterial *)material
//{
//    [super prepareToRenderWithMaterial:material];
//  
//}
@end
