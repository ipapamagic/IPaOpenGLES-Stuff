//
//  GL3DSceneViewController.m
//  IPaGLSample
//
//  Created by IPa Chen on 2015/1/30.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "GL3DSceneViewController.h"
#import "IPaGLEngine.h"
#import "IPaGLCamera.h"
#import "IPaGLSprite3D.h"
#import "IPaGLSprite3DRenderer.h"
@interface GL3DSceneViewController ()

@end

@implementation GL3DSceneViewController
{
    IPaGLCamera *camera;
    IPaGLSprite3D *entity;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    EAGLContext* context = [[IPaGLEngine sharedInstance] defaultContext];
    
    if (!context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    
}
- (void)dealloc
{
    [self tearDownGL];
    GLKView *view = (GLKView *)self.view;
    if ([EAGLContext currentContext] == view.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        GLKView *view = (GLKView *)self.view;
        if ([EAGLContext currentContext] == view.context) {
            [EAGLContext setCurrentContext:nil];
        }
    }
    
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupGL];
}
- (void)setupGL
{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    IPaGLSprite3DRenderer *renderer = [[IPaGLSprite3DRenderer alloc] init];
    entity = [[IPaGLSprite3D alloc] initWithUIImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture" ofType:@"png"]] withName:@"texture" renderer:renderer] ;
    
    entity.size = GLKVector2Make(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
    
    
}

- (void)tearDownGL
{
    entity = nil;
    camera = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [camera renderIPaGLEntity:entity];
}


@end
