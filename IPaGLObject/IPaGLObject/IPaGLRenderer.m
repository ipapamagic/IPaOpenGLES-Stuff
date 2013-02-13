//
//  IPaGLRenderer.m
//  IPaGLObject
//
//  Created by IPaPa on 13/1/13.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLRenderer.h"
#import "IPaGLRenderGroup.h"
#import "IPaGLMaterial.h"
#import "IPaGLObject.h"
@implementation IPaGLRenderer
-(void)renderObject:(IPaGLObject*)object
{
    [self prepareToDraw];
    [object bindBuffer];
    for (IPaGLRenderGroup* group in object.groups) {
        [self renderGroup:group];
    }
}
-(void)renderGroup:(IPaGLRenderGroup*)group
{
    [self prepareToRenderGroup:group];
    [group bindBuffer];
    glDrawElements(GL_TRIANGLES, group.indexNumber, GL_UNSIGNED_SHORT, 0);
}
-(void)prepareToRenderGroup:(IPaGLRenderGroup *)group
{
}
-(void)prepareToDraw
{
    
}
@end

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
    [self onBindGLUniforms];
}
-(void)prepareToRenderGroup:(IPaGLRenderGroup*)group
{
    [group.material bindTexture];
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
-(void)onBindGLAttributes:(GLuint)_program
{
    
}
-(void)onGetGLUniforms:(GLuint)_program
{
}
-(void)onBindGLUniforms
{
}
#pragma mark -  OpenGL ES 2 shader compilation

- (void)loadShaders
{
    
    GLuint vertShader, fragShader;

    
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    NSString *vertShaderPathname = [self vertexShaderFilePath];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return;
    }
    
    // Create and compile fragment shader.
    NSString *fragShaderPathname = [self fragmentShaderFilePath];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
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

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
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


@implementation IPaGLKitRenderer
-(id)init
{
    if (self = [super init])
    {
        self.effect = [[GLKBaseEffect alloc] init];
    }
    
    return self;
}
-(void)prepareToDraw
{
    [self.effect prepareToDraw];
    
}
-(void)prepareToRenderGroup:(IPaGLRenderGroup*)group
{
    IPaGLMaterial *material = group.material;
    UIColor *color = material.diffuse;
    CGFloat r,g,b,a;
    if (color == nil) {
        r = g = b = a = 0;
    }
    else {
        [color getRed:&r green:&g blue:&b alpha:&a];
    }
    self.effect.light0.diffuseColor = GLKVector4Make(r,g,b,a);
    color = material.specular;
    if (color == nil) {
        r = g = b = a = 0;
    }
    else {
        [color getRed:&r green:&g blue:&b alpha:&a];
    }
    self.effect.light0.specularColor = GLKVector4Make(r,g,b,a);
    color = material.ambient;
    if (color == nil) {
        r = g = b = a = 0;
    }
    else {
        [color getRed:&r green:&g blue:&b alpha:&a];
    }
    self.effect.light0.ambientColor = GLKVector4Make(r,g,b,a);
    self.effect.light0.linearAttenuation = material.shininess;
    if (material.textureInfo != nil) {
        self.effect.texture2d0.name = material.textureInfo.name;
//        self.effect.constantColor = GLKVector4Make(0.0, 0.0, 0.0, 1);
        self.effect.texture2d0.enabled = GL_TRUE;
//        self.effect.texture2d0.envMode = GLKTextureEnvModeDecal;
    }
    else {
        self.effect.texture2d0.enabled = GL_FALSE;
    }

}
@end
