//
//  IPaGLPoints2D.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/22.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPaGLPath2DContainer.h"
#import "IPaGLPoints2DRenderer.h"
@import GLKit;
@class IPaGLPath2D;
@interface IPaGLPoints2D : IPaGLPath2DContainer
@property (nonatomic,strong) IPaGLPoints2DRenderer* renderer;
@property (nonatomic,assign) GLfloat pointSize;
@property (nonatomic,assign) GLKVector4 pointColor;
@property (nonatomic,assign) GLKMatrix4 matrix;
@property (nonatomic,strong) IPaGLPath2D *path;
- (instancetype)initWithMaxPointsNumber:(GLint)maxPointsNumber renderer:(IPaGLPoints2DRenderer*)renderer;
- (instancetype)initWithPath:(IPaGLPath2D*)path renderer:(IPaGLPoints2DRenderer*)renderer;
@end
