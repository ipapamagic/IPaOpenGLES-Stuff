//
//  IPaGLWaterRippleEffect.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/23.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface IPaGLWaterRippleEffect : NSObject
-(GLKVector2)displaySize;
-(void)update;
-(void)render;
-(void)createRippleAtPos:(GLKVector2)position;
//call it before you want to draw something to texture of this effect
-(void)bindFrameBuffer;
-(id)initWithSize:(GLKVector2)size meshFactor:(NSUInteger)factor rippleRadius:(NSUInteger)rippleRadius;
@end
