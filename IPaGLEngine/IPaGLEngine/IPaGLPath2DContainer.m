//
//  IPaGLPath2DContainer.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/29.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLPath2DContainer.h"
#import "IPaGLShader2DRenderer.h"
@implementation IPaGLPath2DContainer
- (instancetype)initWithMaxPointsNumber:(GLint)maxPointsNumber renderer:(IPaGLShader2DRenderer*)renderer
{
    return  [self initWithPath:[[IPaGLPath2D alloc] initWithMaxPointsNumber:maxPointsNumber] renderer:renderer];
}
- (instancetype)initWithPath:(IPaGLPath2D*)path renderer:(IPaGLShader2DRenderer*)renderer
{
    self = [super init];
    self.renderer = renderer;
    
    self.matrix = GLKMatrix4Identity;
    self.path = path;
    return self;
}
-(void)dealloc
{
    
    
}
- (void)addPoint:(GLKVector2)point
{
    GLKVector2 displaySize = self.renderer.displaySize;
    GLKVector2 displaySizeRatio =  GLKVector2Make(2/displaySize.x, 2/displaySize.y) ;
    [self.path addGLPoint:GLKVector2Make(-1 + point.x * displaySizeRatio.x, 1 - point.y * displaySizeRatio.y)];
}

- (void)addLine:(GLKVector2)startPoint endPoint:(GLKVector2)endPoint step:(GLint)step
{
    GLKVector2 displaySize = self.renderer.displaySize;
    GLKVector2 displaySizeRatio =  GLKVector2Make(2/displaySize.x, 2/displaySize.y) ;
    GLKVector2 startP = GLKVector2Make(-1 + startPoint.x * displaySizeRatio.x, 1 - startPoint.y * displaySizeRatio.y);
    GLKVector2 endP = GLKVector2Make(-1 + endPoint.x * displaySizeRatio.x, 1 - endPoint.y * displaySizeRatio.y);
    
    GLfloat distance = GLKVector2Distance(startPoint, endPoint);
    GLuint pointNumber = MAX(ceilf(distance) / step,1);
    [self.path addGLLine:startP endGLPoint:endP pointNumber:pointNumber];
    
}
- (void)render
{
    [self.renderer render:self];
    
}
@end
