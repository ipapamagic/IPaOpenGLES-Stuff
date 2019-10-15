//
//  IPaGL2DVelocityAction.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/4/16.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGL2DAction.h"
//action that keep going with velocity
@interface IPaGL2DVelocityAction : IPaGL2DAction
@property (nonatomic,assign) GLKVector2 velocity;
-(id)initWithVelocity:(GLKVector2)velocity;
@end

