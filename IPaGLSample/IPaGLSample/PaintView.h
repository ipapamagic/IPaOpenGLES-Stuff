//
//  PaintView.h
//  IPaGLSample
//
//  Created by IPaPa on 13/3/11.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <GLKit/GLKit.h>
@protocol PaintViewDelegate;
@interface PaintView : GLKView
@property (nonatomic,weak) id <PaintViewDelegate> paintDelegate;
@end
@protocol PaintViewDelegate <NSObject>

- (void) renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end;

@end
