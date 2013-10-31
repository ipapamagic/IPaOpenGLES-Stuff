//
//  IPaGLToonViewController.m
//  IPaGLSample
//
//  Created by IPaPa on 13/6/4.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLToonViewController.h"
#import "IPaGLToonRenderer.h"
#import "IPaGLWavefrontObj.h"
@interface IPaGLToonViewController ()
{
}
@property (strong, nonatomic) EAGLContext *context;


- (void)setupGL;
- (void)tearDownGL;

@end

@implementation IPaGLToonViewController
{
    IPaGLToonRenderer *shaderRenderer;

    IPaGLWavefrontObj *object;
    
    GLKMatrix4 modelViewProjectionMatrix;
    float rotation;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    shaderRenderer = [[IPaGLToonRenderer alloc] init];
    shaderRenderer.shininess = 1;
    shaderRenderer.lightPosition = GLKVector3Make(2, 0, 0);
    shaderRenderer.eyePosition = GLKVector3Make(0, 0, 0);
    //create an IPaGLAttributes to record vertex data
    object = [[IPaGLWavefrontObj alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"uvcube2" ofType:@"obj"]];
    
    glEnable(GL_DEPTH_TEST);
    
    
}

- (void)tearDownGL
{
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -20.0f);
//    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, rotation, 0.0f, 1.0f, 0.0f);
    
    // Compute the model view matrix for the object rendered with GLKit
    GLKMatrix4 modelViewMatrix;
    // Compute the model view matrix for the object rendered with ES2
    modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    //render by renderGroup
    shaderRenderer.modelViewProjectionMatrix = modelViewProjectionMatrix;
    
    [object renderWithRenderer:shaderRenderer];
    
}
@end
