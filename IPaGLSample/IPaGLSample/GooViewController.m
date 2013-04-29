//
//  GooViewController.m
//  IPaGLSample
//
//  Created by IPaPa on 13/4/24.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "GooViewController.h"
#import "IPaGLEngine.h"
#import "IPaGLSprite2DRenderer.h"
#import "IPaGLSprite2D.h"
#import "IPaGLGooEffect.h"
@interface GooViewController ()

@end

@implementation GooViewController
{
    IPaGLGooEffect *effect;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    IPaGLKitSprite2DRenderer *renderer = [[IPaGLKitSprite2DRenderer alloc] initWithDisplaySize:GLKVector2Make(self.view.frame.size.width, self.view.frame.size.height)];
    IPaGLSprite2D* entity = [[IPaGLSprite2D alloc] initWithUIImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"]] withName:@"texture"];
    
    [entity setPosition:GLKVector2Make(0, 0) size:GLKVector2Make(self.view.frame.size.width , self.view.frame.size.height )];
    effect = [[IPaGLGooEffect alloc] initWithSize:GLKVector2Make(self.view.frame.size.width, self.view.frame.size.height) meshFactor:4 gooRadius:50];
    
    [effect bindFrameBuffer];
    glClearColor(0.0,0.0,0.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [entity renderWithRenderer:renderer];
    
    
}

- (void)tearDownGL
{
    
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [effect update];
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(1, 1, 1, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [effect render];
    
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    
    static CGPoint lastPos;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        lastPos = [sender locationInView:self.view];
    }
    CGPoint pos = [sender locationInView:self.view];
    
    [effect velocityFromPos:GLKVector2Make(lastPos.x, lastPos.y) toPos:GLKVector2Make(pos.x, pos.y)];
    
    lastPos = pos;
}

- (IBAction)onReset:(id)sender {
    [effect resetMesh];
}
@end
