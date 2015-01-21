//
//  FrameBufferRenderer.h
//  IPaGLSample
//
//  Created by IPaPa on 13/3/11.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "IPaGLShaderRenderer.h"

@interface FrameBufferRenderer : IPaGLShaderRenderer
@property (nonatomic,assign) CGFloat penSize;
@property (nonatomic,assign) GLKVector4 penColor;

@end
