//
//  SampleIPaGLRender.m
//  IPaGLObjectSample
//
//  Created by IPaPa on 13/1/13.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "SampleIPaGLRenderer.h"
#import "IPaGLRenderGroup.h"
#import "IPaGLMaterial.h"
@implementation SampleIPaGLRenderer
{
    GLint modelViewProjectionMatrixUniform;
    GLint normalMatrixUniform;
    GLint textureUniform;
    GLint diffuseColorUniform;
}
-(NSString*)vertexShaderFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
}
-(NSString*)fragmentShaderFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
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
    textureUniform = glGetUniformLocation(_program, "texture");
    diffuseColorUniform = glGetUniformLocation(_program,"diffuseColor");
}
-(void)onBindGLUniforms
{
    glUniformMatrix4fv(modelViewProjectionMatrixUniform, 1, 0, self.modelViewProjectionMatrix.m);
    glUniformMatrix3fv(normalMatrixUniform, 1, 0, self.normalMatrix.m);
}
-(void)prepareToRenderGroup:(IPaGLRenderGroup*)group
{
    [super prepareToRenderGroup:group];
    CGFloat r,g,b,a;
    [group.material.diffuse getRed:&r green:&g blue:&b alpha:&a];
    glUniform4f(diffuseColorUniform, r, g, b, a);
}
@end
