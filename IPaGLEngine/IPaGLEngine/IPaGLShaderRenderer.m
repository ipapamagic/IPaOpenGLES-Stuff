//
//  IPaGLShaderRenderer.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLShaderRenderer.h"
#import "IPaGLMaterial.h"

@implementation IPaGLShaderRenderer
{
    GLuint program;
}
-(id)init
{
    if (self = [super init])
    {
        [self loadShaders];
    }
    
    return self;
}
-(void)dealloc
{
    if (program) {
        glDeleteProgram(program);
    }
    
}
-(void)prepareToDraw
{
    glUseProgram(program);
//    [self onBindGLUniforms];
}

- (void)setProjectionMatrix:(GLKMatrix4)projectionMatrix
{
    
}
#pragma mark - IPaGLShaderRendererProtocol
-(NSString*)vertexShaderFilePath
{
    return nil;
}
-(NSString*)fragmentShaderFilePath
{
    return nil;
}

-(NSString*)vertexShaderSource
{
    NSString* file = [self vertexShaderFilePath];
    
    return [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
}
-(NSString*)fragmentShaderSource
{
    NSString* file = [self fragmentShaderFilePath];
    return [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
}
-(void)onBindGLAttributes:(GLuint)_program
{
    
}
-(void)onGetGLUniforms:(GLuint)_program
{
}
//-(void)onBindGLUniforms
//{
//}
#pragma mark -  OpenGL ES 2 shader compilation

- (void)loadShaders
{
    
    GLuint vertShader, fragShader;
    
    
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    
    NSString* source = [self vertexShaderSource];
    
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER source:source]) {
        NSLog(@"Failed to compile vertex shader");
        return;
    }
    
    // Create and compile fragment shader.
    source = [self fragmentShaderSource];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER source:source]) {
        NSLog(@"Failed to compile fragment shader");
        return;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    [self onBindGLAttributes:program];
    
    // Link program.
    if (![self linkProgram:program]) {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program) {
            glDeleteProgram(program);
            program = 0;
        }
        
        return;
    }
    
    // Get uniform locations.
    [self onGetGLUniforms:program];
    
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(program, fragShader);
        glDeleteShader(fragShader);
    }
    
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(NSString *)source
{
    GLint status;
    
    
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    const GLchar* charSource = (GLchar *)[source UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &charSource, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
@end
