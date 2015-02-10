//
//  IPaGLEntityRenderer.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/29.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLEntityRenderer.h"
#import "IPaGLEntity.h"
#import "IPaGLCamera.h"
#import "IPaGLRenderSource.h"
@implementation IPaGLEntityRenderer
{
    GLint matrixUniform;
}
- (void)renderEntity:(IPaGLEntity *)entity withCamera:(IPaGLCamera*)camera
{
    [self prepareToDraw];
    [entity.source bindBuffer];
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(camera.viewProjectionMatrix, entity.matrix);
    glUniformMatrix4fv(matrixUniform, 1, 0, modelViewProjectionMatrix.m);
    
}
- (void)onGetGLUniforms:(GLuint)_program
{
    matrixUniform = glGetUniformLocation(_program, "matrix");
}
@end
