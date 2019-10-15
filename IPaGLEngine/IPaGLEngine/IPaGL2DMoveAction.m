//
//  IPaGL2DMoveAction.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/4/16.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGL2DMoveAction.h"

@implementation IPaGL2DMoveAction
{
    GLKVector2 startPosition;
    double startTime;
}
-(id)initWithTargetPos:(GLKVector2)targetPos actionTime:(double)actionTime
{
    self = [super init];
    self.targetPosition = targetPos;
    self.actionTime = actionTime;
    return self;
}
-(void)initialAction
{
    [super initialAction];
    startTime = CACurrentMediaTime();
    startPosition = [self.target position];
    
    
}
-(void)runAction
{
    double timeDiff = currentTickTime - startTime;
    
    float percent = MIN(timeDiff / self.actionTime,1);
    
    GLKVector2 newPos = GLKVector2Lerp(startPosition, self.targetPosition, percent);
    [self.target setPosition:newPos];
    
}
-(BOOL)isComplete
{
    return ((currentTickTime - startTime) >= self.actionTime);
}
@end