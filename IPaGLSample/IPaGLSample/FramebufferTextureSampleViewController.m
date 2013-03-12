//
//  FramebufferTextureSampleViewController.m
//  IPaGLObjectSample
//
//  Created by IPaPa on 13/3/11.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "FramebufferTextureSampleViewController.h"
#import "PaintView.h"
#import "IPaGLTexture.h"
#import "IPaGLFramebufferTexture.h"
#import "IPaGLSprite2D.h"
#import "IPaGLSprite2DRenderer.h"
#import "FrameBufferRenderer.h"
#import "IPaGLRenderSource.h"
#define kBrushPixelStep		3
#define vertexMax 64
@interface FramebufferTextureSampleViewController () <PaintViewDelegate>

@end

@implementation FramebufferTextureSampleViewController
{
    IPaGLSprite2D *sprite;
    IPaGLFramebufferTexture* texture;
//    IPaGLTexture *ttt;
    IPaGLKitSprite2DRenderer *paintRenderer;
    FrameBufferRenderer *framebufferRenderer;
    IPaGLRenderSource *paintAttributes;
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
    
    PaintView *view = (PaintView *)self.view;
    view.context = context;
    view.paintDelegate = self;
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

    CGSize size = CGSizeMake(1, 1);

    while (size.width < self.view.frame.size.width && size.width < 2048) {
        size.width *= 2;
    }
    while (size.height < self.view.frame.size.height && size.height < 2048) {
        size.height *= 2;
    }
    texture = [[IPaGLFramebufferTexture alloc] initWithSize:size];
 
    paintRenderer = [[IPaGLKitSprite2DRenderer alloc] initWithDisplaySize:GLKVector2Make(self.view.bounds.size.width, self.view.bounds.size.height)];
    
    sprite = [[IPaGLSprite2D alloc] init];
    [sprite setTexture:texture.texture];
    sprite.renderer = paintRenderer;

    [sprite setPosition:GLKVector2Make(0, 0) size:GLKVector2Make(size.width, size.height)];
    
    
    framebufferRenderer = [[FrameBufferRenderer alloc] init];
    framebufferRenderer.penColor = GLKVector4Make(0, 0, 0, 1);
    framebufferRenderer.penSize = 10;
    
    paintAttributes = [[IPaGLRenderSource alloc] init];
    paintAttributes.vertexAttributes = malloc(vertexMax * 2 * sizeof(GLfloat));
    paintAttributes.vertexAttributeCount = 0;
    [paintAttributes setAttrHasNormal:NO];
    [paintAttributes setAttrHasTexCoords:NO];
    [paintAttributes setAttrHasPosZ:NO];
    [paintAttributes createBuffer];
    
    
    [texture bindFramebuffer];
    [framebufferRenderer prepareToDraw];
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
  framebufferRenderer.penColor = GLKVector4Make(1, 1, 1, 1);
}

- (IBAction)onSelectBlack:(id)sender {
    [wBtn setSelected:NO];
    [bBtn setSelected:YES];
      framebufferRenderer.penColor = GLKVector4Make(0, 0, 0, 1);
}

- (IBAction)onClear:(id)sender {
    [texture bindFramebuffer];
    [framebufferRenderer prepareToDraw];
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

// Drawings a line onscreen based on where the user touches
- (void) renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end
{
	
	static NSUInteger maxVertex = vertexMax;
    
    GLKView *view = (GLKView *)self.view;
    CGRect viewFrame = view.frame;
	[EAGLContext setCurrentContext:view.context];

  
	// Add points to the buffer so there are drawing points every X pixels
	paintAttributes.vertexAttributeCount = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
    GLfloat* vertexBuffer = paintAttributes.vertexAttributes;
	for(NSUInteger i = 0; i < paintAttributes.vertexAttributeCount; ++i) {
		if(i == maxVertex) {
			maxVertex *= 2;
			paintAttributes.vertexAttributes = realloc(paintAttributes.vertexAttributes, maxVertex * 2 * sizeof(GLfloat));
            vertexBuffer = paintAttributes.vertexAttributes;

		}
		CGFloat x,y;
        x = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)paintAttributes.vertexAttributeCount);
        y = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)paintAttributes.vertexAttributeCount);
    
        //將xy換算成 texture 內的座標
        x = -1 + x / viewFrame.size.width * 2;
        y = 1 - y / viewFrame.size.height * 2 ;
        

//        y = y * texture.framebufferSize.y / itemRect.size.height;
//        y += (texture.framebufferSize.y - itemRect.size.height) / texture.framebufferSize.y * 2 - 1;
       
        
		vertexBuffer[2 * i + 0] = x;
		vertexBuffer[2 * i + 1] = y;
        //   NSLog(@"%f %f",x,y);
		

	}
    
	// Render the vertex array

    [paintAttributes updateAttributeBuffer];
    [texture bindFramebuffer];
    
    glViewport(0, texture.framebufferSize.y - viewFrame.size.height, viewFrame.size.width, viewFrame.size.height);

    [framebufferRenderer prepareToDraw];
    [paintAttributes renderWithRenderer:framebufferRenderer];

    
	glDrawArrays(GL_POINTS, 0, paintAttributes.vertexAttributeCount);
    
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [sprite render];
}
- (void)viewDidUnload {
    bBtn = nil;
    wBtn = nil;
    [super viewDidUnload];
}
@end
