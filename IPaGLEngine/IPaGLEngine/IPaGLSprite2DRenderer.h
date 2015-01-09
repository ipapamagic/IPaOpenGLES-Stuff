//
//  IPaGLSprite2DRenderer.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/7.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "IPaGLRenderer.h"
@protocol IPaGLSprite2DRenderer <NSObject>
//-(void)prepareToRenderWithMatrix:(GLKMatrix4)matrix;
-(void)setDisplaySize:(GLKVector2)size;
-(void)setProjectionMatrix:(GLKMatrix4)projectionMatrix;
-(GLKMatrix4)projectionMatrix;
-(void)setModelMatrix:(GLKMatrix4)modelMatrix;
-(GLKMatrix4)modelMatrix;
@end


@interface IPaGLKitSprite2DRenderer : IPaGLKitRenderer <IPaGLSprite2DRenderer>
@property (nonatomic,assign) GLKVector2 displaySize;
-(id)initWithDisplaySize:(GLKVector2)displaySize;
@end

@interface IPaGLShaderSprite2DRenderer : IPaGLShaderRenderer <IPaGLSprite2DRenderer>
@property (nonatomic,assign) GLKVector2 displaySize;
@property (nonatomic,assign) GLKMatrix4 projectionMatrix;
@property (nonatomic,assign) GLKMatrix4 modelMatrix;
-(id)initWithDisplaySize:(GLKVector2)displaySize;
@end

