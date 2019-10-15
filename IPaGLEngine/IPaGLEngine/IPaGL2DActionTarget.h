//
//  IPaGL2DActionTarget.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/4/27.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GLKit;
@protocol IPaGL2DActionTarget <NSObject>

- (void)setPosition:(GLKVector2)position;
- (GLKVector2)position;
- (void)setAlpha:(CGFloat)alpha;
- (CGFloat)alpha;
- (void)setMatrix:(GLKMatrix4)matrix;
@end