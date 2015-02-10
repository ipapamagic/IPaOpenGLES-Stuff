//
//  IPaGLPath2D.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/29.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import <IPaGLEngine/IPaGLEngine.h>
#import "IPaGLRenderSource.h"
@import GLKit;
@interface IPaGLPath2D : IPaGLRenderSource
@property (nonatomic,assign) GLuint currentPointNum;
- (instancetype)initWithMaxPointsNumber:(GLint)maxPointsNumber;
- (void)addGLPoint:(GLKVector2)point;
- (void)addGLLine:(GLKVector2)startPoint endGLPoint:(GLKVector2)endPoint pointNumber:(GLuint)pointNumber;
- (void)removeAllPoints;
@end
