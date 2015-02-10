//
//  IPaGLEntity.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPaGLEntityRenderer.h"
@import GLKit;
@class IPaGLRenderSource;
@interface IPaGLEntity : NSObject
@property (nonatomic,strong) IPaGLRenderSource *source;
@property (nonatomic,strong) IPaGLEntityRenderer *renderer;
@property (nonatomic,assign) GLKMatrix4 matrix;

@end
