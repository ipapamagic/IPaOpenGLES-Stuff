//
//  IPaGLPoints2D.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/22.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLPoints2D.h"
#import "IPaGLRenderSource.h"
#import "IPaGLPoints2DRenderer.h"
@implementation IPaGLPoints2D
{
    IPaGLRenderSource *source;
    GLuint maxPointsNum;
}
- (instancetype)initWithMaxPointsNumber:(GLint)maxPointsNumber renderer:(IPaGLPoints2DRenderer*)renderer
{
    self = [super init];
    self.renderer = renderer;
    source = [[IPaGLRenderSource alloc] init];
    maxPointsNum = MAX(1,maxPointsNumber);
    source.vertexAttributes = malloc(maxPointsNumber * 2 * sizeof(GLfloat));
    source.vertexAttributeCount = 0;
    [source setAttrHasNormal:NO];
    [source setAttrHasTexCoords:NO];
    [source setAttrHasPosZ:NO];
    self.matrix = GLKMatrix4Identity;
    return self;
}
-(void)dealloc
{
    source = nil;

}
- (void)addPoint:(GLKVector2)point
{

    if ((source.vertexAttributeCount + 1) >= maxPointsNum) {
        [self doublePointsNum];
    }
    GLfloat* vertexBuffer = source.vertexAttributes;
    vertexBuffer[source.vertexAttributeCount * 2] = point.x;
    vertexBuffer[source.vertexAttributeCount * 2 + 1] = point.y;

    source.vertexAttributeCount += 1;
    
    [source createBufferStatic];
}
- (void)doublePointsNum
{
    maxPointsNum *= 2;
    source.vertexAttributes = realloc(source.vertexAttributes, maxPointsNum * 2 * sizeof(GLfloat));
    
}
- (void)addLine:(GLKVector2)startPoint endPoint:(GLKVector2)endPoint step:(GLint)step
{
    GLfloat distance = GLKVector2Distance(startPoint, endPoint);
    GLuint pointNumber = MAX(ceilf(distance) / step,1);
    while ((source.vertexAttributeCount + pointNumber) >= maxPointsNum) {
        [self doublePointsNum];
    }
    GLfloat* vertexBuffer = source.vertexAttributes;
    for(NSUInteger i = source.vertexAttributeCount; i <source.vertexAttributeCount + pointNumber ; ++i) {
        
        GLfloat x,y;
        GLfloat ratio = (GLfloat)(i - source.vertexAttributeCount) / (GLfloat)pointNumber;
        x = startPoint.x + (endPoint.x - startPoint.x) * ratio;
        y = startPoint.y + (endPoint.y - startPoint.y) * ratio;
        
        vertexBuffer[2 * i + 0] = x;
        vertexBuffer[2 * i + 1] = y;
    }

    source.vertexAttributeCount += pointNumber;
    [source createBufferDynamic];
    
    
    
}
- (void)removeAllPoints
{
    source.vertexAttributeCount = 0;
}
- (void)render
{
    //    renderer.projectionMatrix = self.projectionMatrix;
    [self.renderer prepareToRenderPoints2D:self];
    [source renderWithRenderer:self.renderer];
    glDrawArrays(GL_POINTS, 0, (GLsizei)source.vertexAttributeCount);
}
@end
