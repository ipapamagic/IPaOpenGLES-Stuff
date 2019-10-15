//
//  IPaGLPerspectiveSprite2DSampleViewController.m
//  IPaGLSample
//
//  Created by IPa Chen on 2015/1/13.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLPerspectiveSprite2DSampleViewController.h"
#import "IPaGLPerspectiveSprite2DRenderer.h"
#import "IPaGLEngine.h"
#import "IPaGLPerspectiveSprite2D.h"
#import "IPaGLTexture.h"
#import "IPaGLFramebufferTexture.h"
#import "IPaGLSprite2D.h"
#import "IPaGLRenderSource.h"
#import "IPaGLSprite2DRenderer.h"
#define kBrushPixelStep		3
#define vertexMax 64
@implementation IPaGLPerspectiveSprite2DSampleViewController
{
    IPaGLPerspectiveSprite2D* entity;
    IPaGLPerspectiveSprite2DRenderer *renderer;
    __weak IBOutlet UIView *rbView;
    __weak IBOutlet UIView *lbView;
    
    __weak IBOutlet UIView *ruView;
    
    __weak IBOutlet UIView *luView;
    
    __weak IBOutlet UIView *centerView;
    

    
    IPaGLSprite2D *sprite;
//    IPaGLFramebufferTexture* texture;
    //    IPaGLTexture *ttt;
    IPaGLSprite2DRenderer *paintRenderer;
    IPaGLRenderSource *paintAttributes;
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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [entity setPosition:GLKVector2Make(0, 0) size:GLKVector2Make(self.view.frame.size.width, self.view.frame.size.height)];
    centerView.center = CGPointMake(entity.center.x,entity.center.y);
}
- (void)setupGL
{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    renderer = [[IPaGLPerspectiveSprite2DRenderer alloc] initWithDisplaySize:GLKVector2Make(self.view.frame.size.width, self.view.frame.size.height)];
    entity = [[IPaGLPerspectiveSprite2D alloc] initWithUIImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture2" ofType:@"png"]] withName:@"texture" renderer:renderer] ;
    

}

- (void)tearDownGL
{
    entity = nil;
}
- (IBAction)onPanLU:(UIPanGestureRecognizer*)sender {
    
    CGPoint point = [sender locationInView:self.view];
    luView.center = point;
    [entity setCorner:IPaGLPerspectiveSprite2DCornerUpperLeft position:GLKVector2Make(point.x, point.y)];

    centerView.center = CGPointMake(entity.center.x,entity.center.y);
}
- (IBAction)onPanRU:(UIPanGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:self.view];
    ruView.center = point;
    [entity setCorner:IPaGLPerspectiveSprite2DCornerUpperRight position:GLKVector2Make(point.x, point.y)];
    centerView.center = CGPointMake(entity.center.x,entity.center.y);
}
- (IBAction)onPanLB:(UIPanGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:self.view];
    lbView.center = point;
    [entity setCorner:IPaGLPerspectiveSprite2DCornerBottomLeft position:GLKVector2Make(point.x, point.y)];
    centerView.center = CGPointMake(entity.center.x,entity.center.y);
}
- (IBAction)onPanRB:(UIPanGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:self.view];
    rbView.center = point;
    [entity setCorner:IPaGLPerspectiveSprite2DCornerBottomRight position:GLKVector2Make(point.x, point.y)];
    centerView.center = CGPointMake(entity.center.x,entity.center.y);    
}
- (IBAction)onNext:(id)sender {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat y = CGRectGetHeight(self.view.frame) * .5 - width * .5;

    GLKVector2 uv = [entity getUVOfPoint:GLKVector2Make(centerView.center.x,centerView.center.y)];

    [entity setPosition:GLKVector2Make(0, y) size:GLKVector2Make(width, width)];
    centerView.center = CGPointMake(width * uv.x, (y + width) - width * uv.y);

    luView.center = CGPointMake(0, y);
    ruView.center = CGPointMake(width, y);
    lbView.center = CGPointMake(0, y + width);
    rbView.center = CGPointMake(width, y + width);
    
}
- (IBAction)onTap:(UITapGestureRecognizer*)sender {
    centerView.center = [sender locationInView:self.view];
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
    [entity render];
   
}


@end
