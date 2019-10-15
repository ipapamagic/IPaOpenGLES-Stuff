//
//  IPaGL2DAction.H
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/9.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPaGL2DActionTarget.h"
@import GLKit;
@interface IPaGL2DAction : NSObject
{
    double currentTickTime;
    double lastTickTime;
}
@property (nonatomic,weak) id <IPaGL2DActionTarget> target;
@property (nonatomic,copy) void (^completeBlock)();
//check is action complete
-(BOOL)isComplete;
//need to call before update
-(void)initialAction;
-(void)update;
@end


