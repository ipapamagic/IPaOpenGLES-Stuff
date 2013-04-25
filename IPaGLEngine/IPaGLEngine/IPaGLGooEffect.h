//
//  IPaGLGooEffect.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/24.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLEffect.h"

@interface IPaGLGooEffect : IPaGLEffect
-(id)initWithSize:(GLKVector2)size meshFactor:(NSUInteger)factor gooRadius:(NSUInteger)gooRadius;
-(void)velocityFromPos:(GLKVector2)startPos toPos:(GLKVector2)endPos;
@end
