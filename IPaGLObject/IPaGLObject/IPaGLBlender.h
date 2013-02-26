//
//  IPaGLBlender.h
//  IPaGLObject
//
//  Created by IPaPa on 13/2/22.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface IPaGLBlender : NSObject
@property (nonatomic,assign) GLenum sfactor;
@property (nonatomic,assign) GLenum dfactor;
-(void)bindBlendFunc;
@end
