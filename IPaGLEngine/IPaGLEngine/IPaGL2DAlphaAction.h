//
//  IPaGL2DAlphaAction.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/4/16.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//


#import "IPaGL2DAction.h"
@interface IPaGL2DAlphaAction : IPaGL2DAction
@property (nonatomic,assign) GLfloat targetAlpha;
@property (nonatomic,assign) double actionTime;
-(id)initWithTargetAlpha:(CGFloat)alpha actionTime:(double)actionTime;
@end