//
//  IPaGLFramebufferTexture.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "IPaGLFramebufferTexture.h"
#import "IPaGLTexture.h"
#import <OpenGLES/ES2/glext.h>
@implementation IPaGLFramebufferTexture
{
    GLuint framebuffer;
    CGSize textureSize;
}
-(IPaGLFramebufferTexture*)initWithSize:(CGSize)size
{
    return [self initWithSize:size filter:GL_NEAREST];
}
-(IPaGLFramebufferTexture*)initWithSize:(CGSize)texSize filter:(GLenum)filter
{
    self = [super init];
    //  NSInteger temp = 2;
    //  CGSize size  = texSize;
    ////  GLKVector2 texRatio = GLKVector2Make(1, 1);
    int MAX_TEXTURE_SIZE;
    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &MAX_TEXTURE_SIZE);
    if (texSize.width > MAX_TEXTURE_SIZE || texSize.height > MAX_TEXTURE_SIZE) {
        if (texSize.width > texSize.height) {
            textureSize.width = MAX_TEXTURE_SIZE;
            textureSize.height = texSize.height / texSize.width * MAX_TEXTURE_SIZE;
        }
        else {
            textureSize.height = MAX_TEXTURE_SIZE;
            textureSize.width = texSize.width / texSize.height * MAX_TEXTURE_SIZE;
        }
    }
    else {
        textureSize = texSize;
    }
    //    texRatio = GLKVector2Make(textureSize.width / size.width, textureSize.height / size.height);
    
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    GLuint textureName;
    glGenTextures(1, &textureName);
    glBindTexture(GL_TEXTURE_2D, textureName);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureSize.width, textureSize.height,
                 0, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter);
    // specify texture as color attachment
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                           GL_TEXTURE_2D, textureName, 0);
    
    //    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, baseDepthBuffer);
    int status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status != GL_FRAMEBUFFER_COMPLETE)
    {
        switch (status) {
            case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
                NSLog(@"GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT");
                break;
            case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
                NSLog(@"GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT");
                break;
            case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
                NSLog(@"GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS");
                break;
            case GL_FRAMEBUFFER_UNSUPPORTED:
                NSLog(@"GL_FRAMEBUFFER_UNSUPPORTED");
                break;
                
            default:
                NSLog(@"unknown status");
                break;
        }
        return nil;
    }
    
    self.textureName = textureName;
    self.texTarget = GL_TEXTURE_2D;
    self.imageSize = GLKVector2Make(texSize.width, texSize.height);
    self.texCoordRatio = GLKVector2Make(1, 1);
    return self;
    
}
-(void)bindFramebuffer
{
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
//    glViewport(0, 0, self.imageSize.x, self.imageSize.y);
    glViewport(0, 0, textureSize.width, textureSize.height);
}
-(void)dealloc
{
    glDeleteFramebuffers(1, &framebuffer);
}
- (UIImage*)renderToImage
{
    [self bindFramebuffer];
    //  GLint backingWidth, backingHeight;
    //
    //  glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    //  glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    GLint x = 0, y = 0;
    GLint width = textureSize.width;
    GLint height = textureSize.height;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
                                    ref, NULL, true, kCGRenderingIntentDefault);
    width = self.imageSize.x;
    height = self.imageSize.y;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, width, height), iref);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    free(data);
    CFRelease(ref);
    CFRelease(colorspace);
    CGImageRelease(iref);
    return image;
}
@end
