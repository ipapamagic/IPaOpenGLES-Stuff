//
//  IPaGLEntity.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;
@class IPaGLRenderSource;
@protocol IPaGLRenderer;
@interface IPaGLEntity : NSObject
@property (nonatomic,weak) IPaGLRenderSource *source;
@property (nonatomic,weak) id <IPaGLRenderer> renderer;
@property (nonatomic,assign) GLKMatrix4 matrix;
@end
