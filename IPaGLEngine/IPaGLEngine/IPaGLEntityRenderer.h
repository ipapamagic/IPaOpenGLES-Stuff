//
//  IPaGLEntityRenderer.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/29.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLShaderRenderer.h"
@class IPaGLEntity;
@class IPaGLCamera;
@interface IPaGLEntityRenderer : IPaGLShaderRenderer
- (void)renderEntity:(IPaGLEntity *)entity withCamera:(IPaGLCamera*)camera;
@end
