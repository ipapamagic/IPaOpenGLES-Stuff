//
//  IPaGL2DAction.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/9.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "IPaGL2DAction.h"
#import <QuartzCore/QuartzCore.h>

@interface IPaGL2DAction()

@end
@implementation IPaGL2DAction
{
}
- (instancetype)init
{
    self = [super init];
    lastTickTime = 0;
    return self;
}
//-(id)initWithSprite2D:(IPaGL2D*)sprite2D
//{
//    self = [super init];
//    self.sprite2D = sprite2D;
//    
//    return self;
//}
-(BOOL)isComplete
{
    return YES;
}
//need to call before update
-(void)initialAction
{
    lastTickTime = CACurrentMediaTime();
}
-(void)update
{
    if (lastTickTime == 0) {
        [self initialAction];
    }
    currentTickTime = CACurrentMediaTime();
    
    [self runAction];
    
    lastTickTime = currentTickTime;
    if ([self isComplete]) {
        if (self.completeBlock) {
            self.completeBlock();
        }
    }
    
}
-(void)runAction
{
    NSAssert(NO, @"%@ need to over override runAction",[self class]);
}
@end






