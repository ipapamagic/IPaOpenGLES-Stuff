//
//  IPaGLPerspectiveSprite2DRenderer.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/19.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLShader2DRenderer.h"
@class IPaGLPerspectiveSprite2D;
@interface IPaGLPerspectiveSprite2DRenderer : IPaGLShader2DRenderer
- (void)prepareToRenderSprite2D:(IPaGLPerspectiveSprite2D*)sprite;

@end
