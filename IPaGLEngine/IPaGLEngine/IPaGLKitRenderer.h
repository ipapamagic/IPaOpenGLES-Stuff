//
//  IPaGLKitRenderer.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLRenderer.h"
@import GLKit;
@interface IPaGLKitRenderer : NSObject <IPaGLRenderer>
@property (nonatomic,strong) GLKBaseEffect* effect;
-(void)setProjectionMatrix:(GLKMatrix4)projectionMatrix;
-(GLKMatrix4)projectionMatrix;
-(void)setModelMatrix:(GLKMatrix4)modelMatrix;
-(GLKMatrix4)modelMatrix;
@end