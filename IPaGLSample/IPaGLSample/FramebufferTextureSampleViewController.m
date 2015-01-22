//
//  FramebufferTextureSampleViewController.m
//  IPaGLObjectSample
//
//  Created by IPaPa on 13/3/11.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "FramebufferTextureSampleViewController.h"

#import "IPaGLTexture.h"
#import "IPaGLFramebufferTexture.h"
#import "IPaGLSprite2D.h"
#import "IPaGLRenderSource.h"
#import "IPaGLSprite2DRenderer.h"
#import "IPaGLPoints2D.h"
#import "IPaGLPoints2DRenderer.h"

#define kBrushPixelStep		3
#define vertexMax 64
@interface FramebufferTextureSampleViewController () 

@end

@implementation FramebufferTextureSampleViewController
{
    IPaGLSprite2D *sprite;
    IPaGLFramebufferTexture* texture;
//    IPaGLTexture *ttt;
    IPaGLSprite2DRenderer *paintRenderer;
//    FrameBufferRenderer *framebufferRenderer;
//    IPaGLRenderSource *paintAttributes;
    IPaGLPoints2D *points;
    IPaGLPoints2DRenderer *pointRenderer;
    
    
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
 
    paintRenderer = [[IPaGLSprite2DRenderer alloc] initWithDisplaySize:GLKVector2Make(self.view.bounds.size.width, self.view.bounds.size.height)];
    
    sprite = [[IPaGLSprite2D alloc] initWithTexture:texture renderer:paintRenderer];

    [sprite setPosition:GLKVector2Make(0, 0) size:GLKVector2Make(size.width, size.height)];
    pointRenderer = [[IPaGLPoints2DRenderer alloc] initWithDisplaySize:GLKVector2Make(self.view.bounds.size.width, self.view.bounds.size.height)];
    points = [[IPaGLPoints2D alloc] initWithMaxPointsNumber:vertexMax renderer:pointRenderer];

    points.pointColor = GLKVector4Make(0, 0, 0, 1);
    points.pointSize = 10;
    
    
    [texture bindFramebuffer];
//    [framebufferRenderer prepareToDraw];
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}
- (void)tearDownGL
{
    sprite = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSelectWhite:(id)sender {
    [wBtn setSelected:YES];
    [bBtn setSelected:NO];
    points.pointColor = GLKVector4Make(1, 1, 1, 1);
}

- (IBAction)onSelectBlack:(id)sender {
    [wBtn setSelected:NO];
    [bBtn setSelected:YES];
    points.pointColor = GLKVector4Make(0, 0, 0, 1);
}

- (IBAction)onClear:(id)sender {
    [texture bindFramebuffer];
//    [framebufferRenderer prepareToDraw];
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

// Drawings a line onscreen based on where the user touches
- (void) renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end
{
	

    GLKView *view = (GLKView *)self.view;
	[EAGLContext setCurrentContext:view.context];

  
	// Add points to the buffer so there are drawing points every X pixels
    [points addLine:GLKVector2Make(start.x, start.y) endPoint:GLKVector2Make(end.x, end.y) step:kBrushPixelStep];
    
    
    
	// Render the vertex array
    [texture bindFramebuffer];
    
    [points render];
    [points removeAllPoints];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   // glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
   // glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
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
    [self renderLineFromPoint:location toPoint:location];
    
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    CGSize viewSize = self.bounds.size;
	UITouch*			touch = [[event touchesForView:self.view] anyObject];
    
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
    
    CGPoint location = [touch locationInView:self.view];
    CGPoint previousLocation = [touch previousLocationInView:self.view];
	
	[self renderLineFromPoint:previousLocation toPoint:location];
    
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [super touchesEnded:touches withEvent:event];
    UITouch*	touch = [[event touchesForView:self.view] anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    CGPoint previousLocation = [touch previousLocationInView:self.view];
	
	[self renderLineFromPoint:previousLocation toPoint:location];
    
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
}
@end
