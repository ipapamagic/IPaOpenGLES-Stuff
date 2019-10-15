//
//  IPaGL2DScaleAction.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/4/16.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGL2DScaleAction.h"
@implementation IPaGL2DScaleAction
{
    double startTime;
}
-(id)initWithStartScale:(CGFloat)startScale targetScale:(CGFloat)targetScale actionTime:(double)actionTime
{
    self = [super init];
    self.startScale = startScale;
    self.targetScale = targetScale;
    self.actionTime = actionTime;
    
    return self;
}
-(void)initialAction
{
    [super initialAction];
    startTime = CACurrentMediaTime();
}
-(void)runAction
{
    double timeDiff = currentTickTime - startTime;
    
    float percent = MIN(timeDiff / self.actionTime,1);
    
    double scale = self.startScale + (self.targetScale - self.startScale) * percent;


    [self.target setMatrix:GLKMatrix4MakeScale(scale, scale, 1)];
}
-(BOOL)isComplete
{
    return ((currentTickTime - startTime) >= self.actionTime);
}
@end
