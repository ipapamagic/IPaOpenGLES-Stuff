//
//  IPaGLShaderRenderer.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

@import GLKit;


@interface IPaGLShaderRenderer : NSObject
-(NSString*)vertexShaderFilePath;
-(NSString*)fragmentShaderFilePath;
//overwrite theses function , if you want to give shader code with string directly
-(NSString*)vertexShaderSource;
-(NSString*)fragmentShaderSource;
-(void)prepareToDraw;
-(void)onBindGLAttributes:(GLuint)_program;
-(void)onGetGLUniforms:(GLuint)_program;
//-(void)onBindGLUniforms;

@end
