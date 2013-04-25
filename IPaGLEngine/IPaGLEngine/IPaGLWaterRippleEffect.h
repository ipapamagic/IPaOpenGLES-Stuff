//
//  IPaGLWaterRippleEffect.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/23.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "IPaGLEffect.h"
@interface IPaGLWaterRippleEffect : IPaGLEffect
-(id)initWithSize:(GLKVector2)size meshFactor:(NSUInteger)factor rippleRadius:(NSUInteger)rippleRadius;
-(void)createRippleAtPos:(GLKVector2)position;
@end
