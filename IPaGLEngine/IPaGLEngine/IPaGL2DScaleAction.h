//
//  IPaGL2DScaleAction.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/4/16.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGL2DAction.h"
@interface IPaGL2DScaleAction : IPaGL2DAction
@property (nonatomic,assign) GLfloat startScale;
@property (nonatomic,assign) GLfloat targetScale;
@property (nonatomic,assign) double actionTime;
-(id)initWithStartScale:(CGFloat)startScale targetScale:(CGFloat)targetScale actionTime:(double)actionTime;
@end
