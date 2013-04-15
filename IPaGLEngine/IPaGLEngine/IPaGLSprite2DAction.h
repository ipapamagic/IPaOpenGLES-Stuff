//
//  IPaGLSprite2DAction.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/9.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class IPaGLSprite2D;
@interface IPaGLSprite2DAction : NSObject
@property (nonatomic,weak) IPaGLSprite2D *sprite2D;
//check is action complete
-(BOOL)isComplete;
//need to call before update
-(void)initialAction;
-(void)update;
@end

//action that can move to target pos in time
@interface IPaGLSprite2DMoveAction : IPaGLSprite2DAction
@property (nonatomic,assign) GLKVector2 targetPosition;
@property (nonatomic,assign) double actionTime;

-(id)initWithSprite2D:(IPaGLSprite2D*)sprite2D targetPos:(GLKVector2)targetPos actionTime:(double)actionTime;
@end

//action that keep going with velocity
@interface IPaGLSprite2DVelocityAction : IPaGLSprite2DAction
@property (nonatomic,assign) GLKVector2 velocity;
-(id)initWithSprite2D:(IPaGLSprite2D*)sprite2D velocity:(GLKVector2)velocity;
@end


//Fade IPaGLSprite2D

@interface IPaGLSprite2DAlphaAction : IPaGLSprite2DAction
@property (nonatomic,assign) GLfloat targetAlpha;
@property (nonatomic,assign) double actionTime;
-(id)initWithSprite2D:(IPaGLSprite2D*)sprite2D targetAlpha:(CGFloat)alpha actionTime:(double)actionTime;
@end