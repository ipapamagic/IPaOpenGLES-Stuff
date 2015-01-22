//
//  IPaGLPerspectiveSprite2DRenderer.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/19.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLPerspectiveSprite2DRenderer.h"
#import "IPaGLPerspectiveSprite2D.h"
@implementation IPaGLPerspectiveSprite2DRenderer
{
    GLint matrixUniform;
}
- (void)prepareToRenderSprite2D:(IPaGLPerspectiveSprite2D*)sprite
{
    self.modelMatrix = sprite.matrix;
    [self prepareToRenderWithMaterial:sprite.material];
    
}

-(NSString*)vertexShaderSource
{
    return @"attribute vec4 position;\
        attribute vec3 texCoord;\
        varying lowp vec3 v_texCoord;\
        uniform mat4 matrix;\
        void main()\
        {\
            v_texCoord = texCoord;\
            gl_Position = matrix * position;\
        }";
    
}
-(NSString*)fragmentShaderSource
{
    return @"varying lowp vec3 v_texCoord;\
        uniform sampler2D texture;\
        void main(void)\
        {\
            gl_FragColor = texture2DProj(texture, v_texCoord);\
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
