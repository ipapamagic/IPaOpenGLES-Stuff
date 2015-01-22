//
//  IPaGLSprite2DRenderer.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLSprite2DRenderer.h"
#import "IPaGLSprite2D.h"
@implementation IPaGLSprite2DRenderer
{
    GLint matrixUniform;
}

- (void)prepareToRenderSprite2D:(IPaGLSprite2D*)sprite
{
    self.modelMatrix = sprite.matrix;
    [self prepareToRenderWithMaterial:sprite.material];
    
}

-(NSString*)vertexShaderSource
{
    return @"attribute vec4 position;\
        attribute vec2 texCoord;\
        varying lowp vec2 v_texCoord;\
        uniform mat4 matrix;\
        void main()\
        {\
            v_texCoord = texCoord;\
            gl_Position = matrix * position;\
        }";
    
}
-(NSString*)fragmentShaderSource
{
    return @"varying lowp vec2 v_texCoord;\
    uniform sampler2D texture;\
    void main(void)\
    {\
    gl_FragColor = texture2D(texture, v_texCoord);\
    }";
}

-(void)onBindGLAttributes:(GLuint)_program
{
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoord");
    
}
-(void)onGetGLUniforms:(GLuint)_program
{
    matrixUniform = glGetUniformLocation(_program, "matrix");
}
-(void)onBindGLUniforms
{
    GLKMatrix4 matrix = GLKMatrix4Multiply(self.projectionMatrix, self.modelMatrix);
    glUniformMatrix4fv(matrixUniform, 1, 0, matrix.m);
    
}
@end
