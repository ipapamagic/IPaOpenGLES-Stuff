//
//  IPaGLSprite2DAction.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/9.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLSprite2DAction.h"
#import <QuartzCore/QuartzCore.h>
#import "IPaGLSprite2D.h"
@interface IPaGLSprite2DAction()
@property (nonatomic,assign) double currentTickTime;
@property (nonatomic,assign) double lastTickTime;
@end
@implementation IPaGLSprite2DAction
{
}
-(id)initWithSprite2D:(IPaGLSprite2D*)sprite2D
{
    self = [super init];
    self.sprite2D = sprite2D;
    
    return self;
}
-(BOOL)isComplete
{
    return YES;
}
//need to call before update
-(void)initialAction
{
    self.lastTickTime = CACurrentMediaTime();
}
-(void)update
{
   self.currentTickTime = CACurrentMediaTime();
    
    [self runAction];
    
    self.lastTickTime = self.currentTickTime;
}
-(void)runAction
{
    NSAssert(NO, @"%@ need to over override runAction",[self class]);
}
@end


#pragma mark - IPaGLSprite2DMoveAction

@implementation IPaGLSprite2DMoveAction
{
    GLKVector2 startPosition;
    double startTime;    
}
-(id)initWithSprite2D:(IPaGLSprite2D*)sprite2D targetPos:(GLKVector2)targetPos actionTime:(double)actionTime
{
    self = [super initWithSprite2D:sprite2D];
    self.targetPosition = targetPos;
    self.actionTime = actionTime;
    return self;
}
-(void)initialAction
{
    [super initialAction];
    startTime = CACurrentMediaTime();
    startPosition = self.sprite2D.position;
    
    
}
-(void)runAction
{
    double timeDiff = self.currentTickTime - startTime;
    
    float percent = MIN(timeDiff / self.actionTime,1);
    
    GLKVector2 newPos = GLKVector2Make(startPosition.x + (self.targetPosition.x - startPosition.x) * percent, startPosition.y + (self.targetPosition.y - startPosition.y) * percent);
    
    [self.sprite2D setPosition:newPos];
    
}
-(BOOL)isComplete
{
    return ((self.currentTickTime - startTime) >= self.actionTime);
}
@end


#pragma mark - IPaGLSprite2DVelocityAction
@implementation IPaGLSprite2DVelocityAction


-(id)initWithSprite2D:(IPaGLSprite2D*)sprite2D velocity:(GLKVector2)velocity
{
    self = [super initWithSprite2D:sprite2D];
    self.velocity = velocity;
    [self initialAction];
    return self;
}

-(void)runAction
{
    double timeDiff = self.currentTickTime - self.lastTickTime;
    
    
    GLKVector2 newPos = GLKVector2Make(self.sprite2D.position.x + self.velocity.x * timeDiff, self.sprite2D.position.y + self.velocity.y * timeDiff);
    
    [self.sprite2D setPosition:newPos];
    
}

@end


#pragma mark - IPaGLSprite2DAlphaAction
@implementation IPaGLSprite2DAlphaAction
{
    CGFloat startAlpha;
    double startTime;
}
-(id)initWithSprite2D:(IPaGLSprite2D*)sprite2D targetAlpha:(CGFloat)alpha actionTime:(double)actionTime
{
    self = [super initWithSprite2D:sprite2D];
    self.targetAlpha = alpha;
    self.actionTime = actionTime;
    
    return self;
}
-(void)initialAction
{
    [super initialAction];
    startTime = CACurrentMediaTime();
    startAlpha = self.sprite2D.alpha;
    
    
}
-(void)runAction
{
    double timeDiff = self.currentTickTime - startTime;
    
    float percent = MIN(timeDiff / self.actionTime,1);
    
    self.sprite2D.alpha = startAlpha + (self.targetAlpha - startAlpha) * percent;
    
    
}
-(BOOL)isComplete
{
    return ((self.currentTickTime - startTime) >= self.actionTime);
}
@end
