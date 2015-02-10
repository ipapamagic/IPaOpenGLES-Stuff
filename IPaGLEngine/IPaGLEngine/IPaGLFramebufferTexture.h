//
//  IPaGLFramebufferTexture.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "IPaGLTexture.h"
@interface IPaGLFramebufferTexture : IPaGLTexture

-(IPaGLFramebufferTexture*)initWithSize:(CGSize)size;
-(IPaGLFramebufferTexture*)initWithSize:(CGSize)size filter:(GLenum)filter;
-(void)bindFramebuffer;
- (UIImage*)renderToImage;
@end
