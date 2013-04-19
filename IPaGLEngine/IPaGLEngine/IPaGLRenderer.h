//
//  IPaGLRenderer.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/1/13.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
//@class IPaGLRenderGroup;
@class IPaGLMaterial;
@class IPaGLRenderSource;
@interface IPaGLRenderer : NSObject
-(void)prepareToDraw;
-(void)prepareToRenderWithMaterial:(IPaGLMaterial*)material;

@end

@protocol IPaGLShaderRendererProtocol <NSObject>

-(NSString*)vertexShaderFilePath;
-(NSString*)fragmentShaderFilePath;
//overwrite theses function , if you want to give shader code with string directly
-(NSString*)vertexShaderSource;
-(NSString*)fragmentShaderSource;

-(void)onBindGLAttributes:(GLuint)_program;
-(void)onGetGLUniforms:(GLuint)_program;
-(void)onBindGLUniforms;
-(void)prepareToRenderWithMaterial:(IPaGLMaterial *)material;
@end
@interface IPaGLShaderRenderer : IPaGLRenderer <IPaGLShaderRendererProtocol>
@end


@interface IPaGLKitRenderer : IPaGLRenderer
@property (nonatomic,strong) GLKBaseEffect* effect;
-(void)setProjectionMatrix:(GLKMatrix4)projectionMatrix;
-(GLKMatrix4)projectionMatrix;
-(void)setModelMatrix:(GLKMatrix4)modelMatrix;
-(GLKMatrix4)modelMatrix;
@end