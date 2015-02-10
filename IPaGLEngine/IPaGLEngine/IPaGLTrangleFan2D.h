//
//  IPaGLTrangleFan2D.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/28.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPaGLPath2DContainer.h"
#import "IPaGLTrangleFan2DRenderer.h"
@import GLKit;
@class IPaGLPath2D;
@interface IPaGLTrangleFan2D : IPaGLPath2DContainer
@property (nonatomic,strong) IPaGLTrangleFan2DRenderer* renderer;
@property (nonatomic,assign) GLKVector4 fanColor;
@property (nonatomic,assign) GLKMatrix4 matrix;
@property (nonatomic,strong) IPaGLPath2D *path;
- (instancetype)initWithMaxPointsNumber:(GLint)maxPointsNumber renderer:(IPaGLTrangleFan2DRenderer*)renderer;
- (instancetype)initWithPath:(IPaGLPath2D*)path renderer:(IPaGLTrangleFan2DRenderer*)renderer;

@end
