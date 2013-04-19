//
//  IPaGLSprite2DSampleViewController.m
//  IPaGLObjectSample
//
//  Created by IPaPa on 13/3/8.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLSprite2DSampleViewController.h"
#import "IPaGLSprite2D.h"
#import "IPaGLSprite2DRenderer.h"
#import "IPaGLEngine.h"
@implementation IPaGLSprite2DSampleViewController
{
    IPaGLSprite2D* entity;
    IPaGLKitSprite2DRenderer *renderer;
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
    
    renderer = [[IPaGLKitSprite2DRenderer alloc] initWithDisplaySize:GLKVector2Make(self.view.frame.size.width, self.view.frame.size.height)];
    entity = [[IPaGLSprite2D alloc] initWithUIImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture" ofType:@"png"]] withName:@"texture"];
    
    [entity setPosition:GLKVector2Make(100, self.view.frame.size.height / 2) size:GLKVector2Make(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    
}

- (void)tearDownGL
{
    entity = nil;
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
    [entity renderWithRenderer:renderer];
}



@end
