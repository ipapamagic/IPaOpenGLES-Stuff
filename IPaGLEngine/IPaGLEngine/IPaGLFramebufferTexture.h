//
//  IPaGLFramebufferTexture.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class IPaGLTexture;
@interface IPaGLFramebufferTexture : NSObject

@property (nonatomic,strong) IPaGLTexture *texture;
-(IPaGLFramebufferTexture*)initWithSize:(CGSize)size;
-(IPaGLFramebufferTexture*)initWithSize:(CGSize)size filter:(GLenum)filter;
-(void)bindFramebuffer;
-(GLKVector2)framebufferSize;
@end
