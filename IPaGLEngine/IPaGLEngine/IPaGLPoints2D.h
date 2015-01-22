//
//  IPaGLPoints2D.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/22.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;
@class IPaGLPoints2DRenderer;
@interface IPaGLPoints2D : NSObject
@property (nonatomic,weak) IPaGLPoints2DRenderer* renderer;
@property (nonatomic,assign) GLfloat pointSize;
@property (nonatomic,assign) GLKVector4 pointColor;
@property (nonatomic,assign) GLKMatrix4 matrix;
- (instancetype)initWithMaxPointsNumber:(GLint)maxPointsNumber renderer:(IPaGLPoints2DRenderer*)renderer;

- (void)addPoint:(GLKVector2)point;
- (void)addLine:(GLKVector2)startPoint endPoint:(GLKVector2)endPoint step:(GLint)step;
- (void)removeAllPoints;
- (void)render;
@end
