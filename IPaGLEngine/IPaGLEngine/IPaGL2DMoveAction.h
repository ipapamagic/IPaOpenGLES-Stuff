//
//  IPaGL2DMoveAction.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/4/16.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//


#import "IPaGL2DAction.h"
//action that can move to target pos in time
@interface IPaGL2DMoveAction : IPaGL2DAction
@property (nonatomic,assign) GLKVector2 targetPosition;
@property (nonatomic,assign) double actionTime;

-(id)initWithTargetPos:(GLKVector2)targetPos actionTime:(double)actionTime;
@end