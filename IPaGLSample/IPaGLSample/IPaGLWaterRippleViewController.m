//
//  IPaGLWaterRippleViewController.m
//  IPaGLSample
//
//  Created by IPaPa on 13/4/23.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLWaterRippleViewController.h"
#import "IPaGLSprite2D.h"
#import "IPaGLWaterRippleEffect.h"
#import "IPaGLSprite2DRenderer.h"
#import "IPaGLEngine.h"
@interface IPaGLWaterRippleViewController ()

@end

@implementation IPaGLWaterRippleViewController
{

    IPaGLWaterRippleEffect *rippleEffect;
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
    IPaGLSprite2D* entity = [[IPaGLSprite2D alloc] initWithUIImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rock" ofType:@"png"]] withName:@"texture"];
    
    [entity setPosition:GLKVector2Make(0, 0) size:GLKVector2Make(self.view.frame.size.width , self.view.frame.size.height )];
    rippleEffect = [[IPaGLWaterRippleEffect alloc] initWithSize:GLKVector2Make(self.view.frame.size.width, self.view.frame.size.height) meshFactor:4 rippleRadius:5];
    
    [rippleEffect bindFrameBuffer];
    glClearColor(1.0,0.0,0.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [entity renderWithRenderer:renderer];

    
}

- (void)tearDownGL
{
 
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [rippleEffect update];
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [rippleEffect render];
    
}


- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    
    CGPoint pos = [sender locationInView:self.view];
    
    [rippleEffect createRippleAtPos:GLKVector2Make(pos.x, pos.y)];
    
}
@end
