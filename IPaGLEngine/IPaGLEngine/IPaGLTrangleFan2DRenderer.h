//
//  IPaGLTrangleFan2DRenderer.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/28.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLShader2DRenderer.h"
@class IPaGLTrangleFan2D;
@interface IPaGLTrangleFan2DRenderer : IPaGLShader2DRenderer
- (void)render:(IPaGLTrangleFan2D*)trangleFan;
@end
