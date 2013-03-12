//
//  IPaGLFramebufferTexture.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLFramebufferTexture.h"
#import "IPaGLTexture.h"
@implementation IPaGLFramebufferTexture
{
    GLuint framebuffer;
}
-(IPaGLFramebufferTexture*)initWithSize:(CGSize)size
{
    self = [super init];
    self.framebufferSize = GLKVector2Make(size.width, size.height);
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
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    // specify texture as color attachment
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                           GL_TEXTURE_2D, textureName, 0);
    
    //    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, baseDepthBuffer);
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
	{
		NSLog(@"Texture frame buffer not complete!");
        return nil;
	}
    self.texture = [[IPaGLTexture alloc] init];
    self.texture.textureName = textureName;
    self.texture.texTarget = GL_TEXTURE_2D;
    
    return self;

}
-(void)bindFramebuffer
{
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
}
-(void)dealloc
{
    glDeleteFramebuffers(1, &framebuffer);
}

@end