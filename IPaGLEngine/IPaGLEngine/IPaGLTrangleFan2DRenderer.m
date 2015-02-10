//
//  IPaGLTrangleFan2DRenderer.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/28.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLTrangleFan2DRenderer.h"
#import "IPaGLTrangleFan2D.h"
@implementation IPaGLTrangleFan2DRenderer
{
    GLint fanColorUniform;
    GLint matrixUniform;
}
-(NSString*)vertexShaderSource
{
    return @"attribute vec4 position;\
            uniform vec4 fanColor;\
            varying lowp vec4 colorVarying;\
            uniform mat4 matrix;\
            void main()\
            {\
                colorVarying = fanColor;\
                gl_Position = matrix * position;\
            }";
    
}
-(NSString*)fragmentShaderSource
{
    return @"varying lowp vec4 colorVarying;\
            void main()\
            {\
                gl_FragColor = colorVarying;\
            }";
}
-(void)onBindGLAttributes:(GLuint)_program
{
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
}
-(void)onGetGLUniforms:(GLuint)_program
{
    fanColorUniform = glGetUniformLocation(_program, "fanColor");
    matrixUniform = glGetUniformLocation(_program, "matrix");
}

- (void)render:(IPaGLTrangleFan2D*)trangleFan
{
    [self prepareToDraw];
    
    glUniform4fv(fanColorUniform, 1, trangleFan.fanColor.v);
    GLKMatrix4 matrix = GLKMatrix4Multiply(self.projectionMatrix, trangleFan.matrix);
    glUniformMatrix4fv(matrixUniform, 1, 0, matrix.m);
    [trangleFan.path bindBuffer];
    glDrawArrays(GL_TRIANGLE_FAN, 0, (GLsizei)trangleFan.path.currentPointNum);
}
@end
