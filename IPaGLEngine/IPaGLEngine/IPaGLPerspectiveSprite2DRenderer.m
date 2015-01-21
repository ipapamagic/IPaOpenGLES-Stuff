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
-(id)init
{
    if (self = [super init]) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        self.displaySize = GLKVector2Make(size.width, size.height);
        
    }
    return self;
}
-(id)initWithDisplaySize:(GLKVector2)displaySize
{
    if (self = [super init]) {
        self.displaySize = displaySize;
    }
    return self;
}
-(void)setDisplaySize:(GLKVector2)displaySize
{
    _displaySize = displaySize;
    
    
    GLKMatrix4 matrix = GLKMatrix4MakeScale( 2/displaySize.x, -2/displaySize.y, 1);
    matrix = GLKMatrix4Translate(matrix, -displaySize.x * .5, -displaySize.y * .5, 0);
    
    self.projectionMatrix = matrix;
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
