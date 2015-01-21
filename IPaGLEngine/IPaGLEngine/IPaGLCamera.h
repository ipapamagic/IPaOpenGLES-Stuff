//
//  IPaGLCamera.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;
@class IPaGLEntity;
@protocol IPaGLRenderer;
@interface IPaGLCamera : NSObject
@property (nonatomic,assign) GLKMatrix4 projectionMatrix;
@property (nonatomic,assign) GLKMatrix4 matrix;
- (instancetype)initWithFovyRadians:(GLfloat)fovyRadians displaySize:(CGSize)displaySize nearZ:(GLfloat)nearZ farZ:(GLfloat)farZ;

- (void)renderIPaGLEntity:(IPaGLEntity*)entity;
@end
