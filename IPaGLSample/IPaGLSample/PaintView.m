//
//  PaintView.m
//  IPaGLSample
//
//  Created by IPaPa on 13/3/11.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "PaintView.h"

@implementation PaintView
{


}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    
    UITouch*	touch = [[event touchesForView:self] anyObject];
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
	CGPoint location = [touch locationInView:self];
    [self.paintDelegate renderLineFromPoint:location toPoint:location];

}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    CGSize viewSize = self.bounds.size;
	UITouch*			touch = [[event touchesForView:self] anyObject];
    
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
    
    CGPoint location = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
	
	[self.paintDelegate renderLineFromPoint:previousLocation toPoint:location];
    
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{


    UITouch*	touch = [[event touchesForView:self] anyObject];
    
    CGPoint location = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
	
	[self.paintDelegate renderLineFromPoint:previousLocation toPoint:location];
    
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
}

@end
