//
//  IPaGLSprite3DRenderer.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/30.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLSprite3DRenderer.h"
#import "IPaGLCamera.h"
#import "IPaGLSprite3D.h"
#import "IPaGLMaterial.h"
#import "IPaGLRenderSource.h"
@implementation IPaGLSprite3DRenderer
{
    
}

- (NSString*)vertexShaderSource
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
    [super onGetGLUniforms:_program];

}

- (void)renderEntity:(IPaGLSprite3D *)entity withCamera:(IPaGLCamera*)camera
{
    [super renderEntity:entity withCamera:camera];
    [entity.material bindTexture];
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    
}
@end
