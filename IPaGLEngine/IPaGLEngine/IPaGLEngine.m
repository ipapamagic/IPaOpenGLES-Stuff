//
//  IPaGLEngine.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/7.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLEngine.h"
@interface IPaGLEngine()
@property (nonatomic,readwrite,strong) EAGLContext* defaultContext;
@end
@implementation IPaGLEngine
static IPaGLEngine *engine = nil;
+(IPaGLEngine*)sharedInstance
{
    @synchronized(self) {
        if (engine == nil) {
            engine = [[self alloc] init];
        }
    }
    return engine;
}
-(EAGLContext*)defaultContext
{
    if (_defaultContext == nil) {
        _defaultContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        if (!_defaultContext) {
            NSLog(@"IPaGLEngine:Failed to create ES context");
        }
    }
    return _defaultContext;
}
-(void)dealloc
{
    if ([EAGLContext currentContext] == self.defaultContext) {
        [EAGLContext setCurrentContext:nil];
    }
    self.defaultContext = nil;
}

@end
