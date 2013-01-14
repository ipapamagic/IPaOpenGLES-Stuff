//
//  IPaGLRenderer.h
//  IPaGLObject
//
//  Created by IPaPa on 13/1/13.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class IPaGLRenderGroup;
@class IPaGLObject;
@interface IPaGLRenderer : NSObject
-(void)renderGroup:(IPaGLRenderGroup*)group;
-(void)prepareToDraw;
-(void)prepareToRenderGroup:(IPaGLRenderGroup*)group;
-(void)renderObject:(IPaGLObject*)object;
@end

@protocol IPaGLShaderRendererProtocol <NSObject>

-(NSString*)vertexShaderFilePath;
-(NSString*)fragmentShaderFilePath;
-(void)onBindGLAttributes:(GLuint)_program;
-(void)onGetGLUniforms:(GLuint)_program;
-(void)onBindGLUniforms;
@end
@interface IPaGLShaderRenderer : IPaGLRenderer <IPaGLShaderRendererProtocol>
@end


@interface IPaGLKitRenderer : IPaGLRenderer
@property (nonatomic,strong) GLKBaseEffect* effect;
@end