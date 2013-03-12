//
//  IPaGLSprite2DRenderer.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/7.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "IPaGLRenderer.h"
@protocol IPaGLSprite2DRenderer <NSObject>
-(void)setModelViewMatrix:(GLKMatrix4)matrix;
-(void)setDisplaySize:(GLKVector2)size;
//inverse of displaySize
-(GLKVector2)displaySizeRatio;
@end



@interface IPaGLKitSprite2DRenderer : IPaGLKitRenderer <IPaGLSprite2DRenderer>
@property (nonatomic,assign) GLKVector2 displaySize;
-(id)initWithDisplaySize:(GLKVector2)displaySize;
@end

@interface IPaGLShaderSprite2DRenderer : IPaGLShaderRenderer <IPaGLSprite2DRenderer>
@property (nonatomic,assign) GLKVector2 displaySize;
-(id)initWithDisplaySize:(GLKVector2)displaySize;
@end