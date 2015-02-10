//
//  TrangleFan2DFramebufferTextureViewController.m
//  IPaGLSample
//
//  Created by IPa Chen on 2015/1/29.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "TrangleFan2DFramebufferTextureViewController.h"
#import "IPaGLFramebufferTexture.h"
#import "IPaGLSprite2D.h"
#import "IPaGLSprite2DRenderer.h"
#import "IPaGLTrangleFan2D.h"
#import "IPaGLTrangleFan2DRenderer.h"
@interface TrangleFan2DFramebufferTextureViewController ()

@end

@implementation TrangleFan2DFramebufferTextureViewController
{
    __weak IBOutlet UIButton *bBtn;
    __weak IBOutlet UIButton *wBtn;
    IPaGLSprite2D *sprite;
    IPaGLFramebufferTexture* texture;
    IPaGLTrangleFan2D *trangleFan;
    
//    IPaGLSprite2DRenderer *paintRenderer;
//    //    FrameBufferRenderer *framebufferRenderer;
//    //    IPaGLRenderSource *paintAttributes;
//    IPaGLPoints2D *points;
//    IPaGLPoints2DRenderer *pointRenderer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:context];
    [bBtn setSelected:YES];
    [wBtn setSelected:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClearColor:(id)sender {
}
- (IBAction)onWhiteColor:(id)sender {
    [wBtn setSelected:YES];
    [bBtn setSelected:NO];
    trangleFan.fanColor = GLKVector4Make(1, 1, 1, 1);
}

- (IBAction)onBlackColor:(id)sender {
    [wBtn setSelected:NO];
    [bBtn setSelected:YES];
    trangleFan.fanColor = GLKVector4Make(0, 0, 0, 1);
}

- (IBAction)onClear:(id)sender {
    [texture bindFramebuffer];
    //    [framebufferRenderer prepareToDraw];
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupGL];
}
- (void)dealloc
{
    [self tearDownGL];
    GLKView *view = (GLKView *)self.view;
    if ([EAGLContext currentContext] == view.context) {
        [EAGLContext setCurrentContext:nil];
    }
}
-(void)setupGL
{
    CGSize size = self.view.frame.size;
    
    texture = [[IPaGLFramebufferTexture alloc] initWithSize:self.view.frame.size];
    
    IPaGLSprite2DRenderer *paintRenderer = [[IPaGLSprite2DRenderer alloc] initWithDisplaySize:GLKVector2Make(self.view.bounds.size.width, self.view.bounds.size.height)];
    
    sprite = [[IPaGLSprite2D alloc] initWithTexture:texture renderer:paintRenderer];
    
    [sprite setPosition:GLKVector2Make(0, 0) size:GLKVector2Make(size.width, size.height)];
    IPaGLTrangleFan2DRenderer *fanRenderer = [[IPaGLTrangleFan2DRenderer alloc] initWithDisplaySize:GLKVector2Make(self.view.bounds.size.width, self.view.bounds.size.height)];
    trangleFan = [[IPaGLTrangleFan2D alloc] initWithMaxPointsNumber:64 renderer:fanRenderer];
    
    trangleFan.fanColor = GLKVector4Make(0, 0, 0, 1);
 
    
    
    [texture bindFramebuffer];
    //    [framebufferRenderer prepareToDraw];
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}
- (void)tearDownGL
{
    sprite = nil;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    //    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //    [points render];
    [sprite render];
    
}
- (void)viewDidUnload {
    bBtn = nil;
    wBtn = nil;
    [super viewDidUnload];
}


// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch*	touch = [[event touchesForView:self.view] anyObject];
    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    CGPoint location = [touch locationInView:self.view];

    [trangleFan addPoint:GLKVector2Make(location.x, location.y)];
    // Render the vertex array
    [texture bindFramebuffer];
    
    [trangleFan render];
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    CGSize viewSize = self.bounds.size;
    UITouch*			touch = [[event touchesForView:self.view] anyObject];
    
    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    
    CGPoint location = [touch locationInView:self.view];

    [trangleFan addPoint:GLKVector2Make(location.x, location.y)];
    // Render the vertex array
    [texture bindFramebuffer];
    
    [trangleFan render];
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [super touchesEnded:touches withEvent:event];
    UITouch*	touch = [[event touchesForView:self.view] anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    [trangleFan addPoint:GLKVector2Make(location.x, location.y)];
    // Render the vertex array
    [texture bindFramebuffer];
    
    [trangleFan render];
    [trangleFan.path removeAllPoints];
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    // If appropriate, add code necessary to save the state of the application.
    // This application is not saving state.
}
@end
