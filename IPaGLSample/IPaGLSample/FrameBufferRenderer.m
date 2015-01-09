//
//  FrameBufferRenderer.m
//  IPaGLSample
//
//  Created by IPaPa on 13/3/11.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "FrameBufferRenderer.h"

@implementation FrameBufferRenderer
{
    GLint penSizeUniform;
    GLint pointColorUniform;
}
-(NSString*)vertexShaderFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"FrameBufferShader" ofType:@"vsh"];
}
-(NSString*)fragmentShaderFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"FrameBufferShader" ofType:@"fsh"];
}
-(void)onBindGLAttributes:(GLuint)_program
{
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
}
-(void)onGetGLUniforms:(GLuint)_program
{
    penSizeUniform = glGetUniformLocation(_program, "pointSize");
    pointColorUniform = glGetUniformLocation(_program, "pointColor");
}
-(void)onBindGLUniforms
{
    glUniform1f(penSizeUniform,self.penSize);
    glUniform4fv(pointColorUniform, 1, self.penColor.v);

}

@end
