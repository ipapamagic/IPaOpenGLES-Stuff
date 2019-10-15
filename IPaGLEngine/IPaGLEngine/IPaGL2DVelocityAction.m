//
//  IPaGL2DVelocityAction.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/4/16.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGL2DVelocityAction.h"
@implementation IPaGL2DVelocityAction


-(id)initWithVelocity:(GLKVector2)velocity
{
    self = [super init];
    self.velocity = velocity;
    return self;
}

-(void)runAction
{
    double timeDiff = currentTickTime - lastTickTime;
    
    GLKVector2 position = [self.target position];
    GLKVector2 newPos = GLKVector2Make(position.x + self.velocity.x * timeDiff, position.y + self.velocity.y * timeDiff);
    
    [self.target setPosition:newPos];
    
}

@end