//
//  IPaViewController.m
//  IPaGLObjectSample
//
//  Created by IPaPa on 13/1/13.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaViewController.h"
#import "SampleIPaGLRenderer.h"

#import "IPaWavefrontObjLoader.h"
#import "IPaGLObject.h"
#import "IPaGLRenderGroup.h"
#import <QuartzCore/CAAnimation.h>
@interface IPaViewController () {
  
    
}
@property (strong, nonatomic) EAGLContext *context;


- (void)setupGL;
- (void)tearDownGL;

@end

@implementation IPaViewController
{
    SampleIPaGLRenderer *shaderRenderer;
    IPaGLKitRenderer *glkRenderer;
    IPaGLObject *object;
    
    
    GLKMatrix4 modelViewProjectionMatrix;
    GLKMatrix3 normalMatrix;
    GLKMatrix4 modelViewProjectionMatrix2;
    GLKMatrix3 normalMatrix2;
    
    
    GLKMatrix4 modelViewMatrixForGLKit;
    GLKMatrix4 modelViewMatrixForGLKit2;
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
    
    shaderRenderer = [[SampleIPaGLRenderer alloc] init];
    glkRenderer = [[IPaGLKitRenderer alloc] init];
    object = [IPaWavefrontObjLoader loadIPaGLObjectFromObjFile:[[NSBundle mainBundle] pathForResource:@"uvcube2" ofType:@"obj"]];
    [object createBuffer];

    
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

    glkRenderer.effect.transform.projectionMatrix = projectionMatrix;
   
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -20.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, rotation, 0.0f, 1.0f, 0.0f);
    
    // Compute the model view matrix for the object rendered with GLKit
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    modelViewMatrixForGLKit = modelViewMatrix;

    
    // Compute the model view matrix for the object rendered with ES2
    modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    
    modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    // Compute the model view matrix for the object rendered with GLKit
    modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 4.0f, -1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    modelViewMatrixForGLKit2 = modelViewMatrix;
   // Compute the model view matrix for the object rendered with ES2
    modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 4.0f, 1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    normalMatrix2 = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    
    modelViewProjectionMatrix2 = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
   
    //render by renderGroup
    shaderRenderer.modelViewProjectionMatrix = modelViewProjectionMatrix;
    shaderRenderer.normalMatrix = normalMatrix;
    shaderRenderer.rotation = rotation;
    
    glkRenderer.effect.transform.modelviewMatrix = modelViewMatrixForGLKit;
   
    
    [object bindBuffer];
    double CurrentTime = CACurrentMediaTime();
    for (IPaGLRenderGroup *group in object.groups) {
        [shaderRenderer prepareToDraw];
        [shaderRenderer renderGroup:group];
        [glkRenderer prepareToDraw];        
        [glkRenderer renderGroup:group];
    }
    double finishedTime = CACurrentMediaTime();
    
//    NSLog(@"render by group take %f",finishedTime - CurrentTime);
    
    //render by object
    shaderRenderer.modelViewProjectionMatrix = modelViewProjectionMatrix2;
    shaderRenderer.normalMatrix = normalMatrix2;
    shaderRenderer.rotation = rotation;
    glkRenderer.effect.transform.modelviewMatrix = modelViewMatrixForGLKit2;
    CurrentTime = CACurrentMediaTime();
    [shaderRenderer renderObject:object];
    [glkRenderer renderObject:object];
    finishedTime = CACurrentMediaTime();  
    
//    NSLog(@"render by object take %f",finishedTime - CurrentTime);
    
    
}



@end
