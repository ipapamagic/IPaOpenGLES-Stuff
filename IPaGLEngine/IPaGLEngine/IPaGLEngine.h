//
//  IPaGLEngine.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/7.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class IPaGLSprite2D;
@interface IPaGLEngine : NSObject
@property (nonatomic,readonly) EAGLContext* defaultContext;
+(IPaGLEngine*)sharedInstance;
@end
