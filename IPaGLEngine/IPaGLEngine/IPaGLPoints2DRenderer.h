//
//  IPaGLPoints2DRenderer.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/22.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLShader2DRenderer.h"
@class IPaGLPoints2D;
@interface IPaGLPoints2DRenderer : IPaGLShader2DRenderer
@property (nonatomic,assign) GLfloat penSize;
@property (nonatomic,assign) GLKVector4 penColor;
@property (nonatomic,assign) GLfloat radiusFactor;
- (void)prepareToRenderPoints2D:(IPaGLPoints2D*)points;
-(id)initWithDisplaySize:(GLKVector2)displaySize radiusFactor:(GLfloat)factor;
@end
