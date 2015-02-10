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
}
-(IPaGLFramebufferTexture*)initWithSize:(CGSize)size
{
    return [self initWithSize:size filter:GL_NEAREST];
}
-(IPaGLFramebufferTexture*)initWithSize:(CGSize)size filter:(GLenum)filter
{
    self = [super init];
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    //    glGenRenderbuffers(1, &baseDepthBuffer);
    //    glBindRenderbuffer(GL_RENDERBUFFER, baseDepthBuffer);
    //    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.bounds.size.width, self.bounds.size.height);
    GLuint textureName;
    glGenTextures(1, &textureName);
    glBindTexture(GL_TEXTURE_2D, textureName);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size.width, size.height,
                 0, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter);
    // specify texture as color attachment
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                           GL_TEXTURE_2D, textureName, 0);
    
    //    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, baseDepthBuffer);
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
	{
		NSLog(@"Texture frame buffer not complete!");
        return nil;
	}

    self.textureName = textureName;
    self.texTarget = GL_TEXTURE_2D;
    self.imageSize = GLKVector2Make(size.width, size.height);
    self.texCoordRatio = GLKVector2Make(1, 1);
    return self;

}
-(void)bindFramebuffer
{
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glViewport(0, 0, self.imageSize.x, self.imageSize.y);
}
-(void)dealloc
{
    glDeleteFramebuffers(1, &framebuffer);
}
- (UIImage*)renderToImage
{
    [self bindFramebuffer];
    GLint backingWidth, backingHeight;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    GLint x = 0, y = 0;
    GLint width = self.imageSize.x;
    GLint height = self.imageSize.y;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
                                    ref, NULL, true, kCGRenderingIntentDefault);
    
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
