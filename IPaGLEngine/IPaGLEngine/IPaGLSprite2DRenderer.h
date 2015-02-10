//
//  IPaGLSprite2DRenderer.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLShader2DRenderer.h"
@class IPaGLSprite2D;
@interface IPaGLSprite2DRenderer : IPaGLShader2DRenderer
- (void)render:(IPaGLSprite2D*)sprite;

@end
