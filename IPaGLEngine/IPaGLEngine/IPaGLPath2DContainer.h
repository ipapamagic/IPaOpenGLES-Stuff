//
//  IPaGLPath2DContainer.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/29.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPaGLPath2D.h"
@class IPaGLShader2DRenderer;

@import GLKit;
@interface IPaGLPath2DContainer : NSObject
@property (nonatomic,strong) IPaGLShader2DRenderer* renderer;
@property (nonatomic,assign) GLKMatrix4 matrix;
@property (nonatomic,strong) IPaGLPath2D *path;
- (instancetype)initWithMaxPointsNumber:(GLint)maxPointsNumber renderer:(IPaGLShader2DRenderer*)renderer;
- (instancetype)initWithPath:(IPaGLPath2D*)path renderer:(IPaGLShader2DRenderer*)renderer;
- (void)addPoint:(GLKVector2)point;
- (void)addLine:(GLKVector2)startPoint endPoint:(GLKVector2)endPoint step:(GLint)step;
- (void)render;
@end
