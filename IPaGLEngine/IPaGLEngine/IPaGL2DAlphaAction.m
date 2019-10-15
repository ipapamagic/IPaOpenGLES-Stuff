//
//  IPaGL2DAlphaAction.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/4/16.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGL2DAlphaAction.h"
@implementation IPaGL2DAlphaAction
{
    CGFloat startAlpha;
    double startTime;
}
-(id)initWithTargetAlpha:(CGFloat)alpha actionTime:(double)actionTime
{
    self = [super init];
    self.targetAlpha = alpha;
    self.actionTime = actionTime;
    
    return self;
}
-(void)initialAction
{
    [super initialAction];
    startTime = CACurrentMediaTime();
    startAlpha = [self.target alpha];
    
    
}
-(void)runAction
{
    double timeDiff = currentTickTime - startTime;
    
    float percent = MIN(timeDiff / self.actionTime,1);
    
    [self.target setAlpha:startAlpha + (self.targetAlpha - startAlpha) * percent];
    
    
}
-(BOOL)isComplete
{
    return ((currentTickTime - startTime) >= self.actionTime);
}
@end