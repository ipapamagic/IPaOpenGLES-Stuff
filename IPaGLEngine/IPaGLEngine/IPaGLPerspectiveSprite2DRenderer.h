//
//  IPaGLPerspectiveSprite2DRenderer.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/19.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLShaderRenderer.h"
@class IPaGLPerspectiveSprite2D;
@interface IPaGLPerspectiveSprite2DRenderer : IPaGLShaderRenderer
- (void)prepareToRenderSprite2D:(IPaGLPerspectiveSprite2D*)sprite;
@property (nonatomic,assign) GLKVector2 displaySize;
@property (nonatomic,assign) GLKMatrix4 projectionMatrix;
@property (nonatomic,assign) GLKMatrix4 modelMatrix;
-(id)initWithDisplaySize:(GLKVector2)displaySize;
@end
