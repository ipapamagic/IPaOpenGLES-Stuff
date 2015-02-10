//
//  IPaGLPath2D.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/29.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLPath2D.h"

@implementation IPaGLPath2D
- (instancetype)initWithMaxPointsNumber:(GLint)maxPointsNumber
{
    self = [super init];
    maxPointsNumber = MAX(1,maxPointsNumber);
    self.vertexAttributes = malloc(maxPointsNumber * 2 * sizeof(GLfloat));
    self.vertexAttributeCount = maxPointsNumber;
    self.currentPointNum = 0;
    [self setAttrHasNormal:NO];
    [self setAttrHasTexCoords:NO];
    [self setAttrHasPosZ:NO];
    [self createBufferStatic];
    return self;
}
-(void)dealloc
{
    
    
}
- (void)addGLPoint:(GLKVector2)point
{
    BOOL needRealloc = NO;
    if ((self.currentPointNum + 1) >= self.vertexAttributeCount) {
        [self doublePointsNum];
        needRealloc = YES;
    }
    GLfloat* vertexBuffer = self.vertexAttributes;

    vertexBuffer[self.currentPointNum * 2] = point.x;
    vertexBuffer[self.currentPointNum * 2 + 1] = point.y;
    
    self.currentPointNum += 1;
    
    if (needRealloc) {
        [self removeBuffer];
        [self createBufferDynamic];
    }
    else {
        [self updateAttributeBuffer];
    }
}
- (void)doublePointsNum
{
    self.vertexAttributeCount *= 2;
    self.vertexAttributes = realloc(self.vertexAttributes, self.vertexAttributeCount * 2 * sizeof(GLfloat));
    
}
- (void)addGLLine:(GLKVector2)startPoint endGLPoint:(GLKVector2)endPoint pointNumber:(GLuint)pointNumber
{
    BOOL needRealloc = NO;
    while ((self.currentPointNum + pointNumber) >= self.vertexAttributeCount) {
        [self doublePointsNum];
        needRealloc = YES;
    }
    GLfloat* vertexBuffer = self.vertexAttributes;
    
    for(GLuint i = self.currentPointNum; i <self.currentPointNum + pointNumber ; ++i) {
        
        GLfloat x,y;
        GLfloat ratio = (GLfloat)(i - self.currentPointNum) / (GLfloat)pointNumber;
        x = startPoint.x + (endPoint.x - startPoint.x) * ratio;
        y = startPoint.y + (endPoint.y - startPoint.y) * ratio;
        
        vertexBuffer[2 * i + 0] = x;
        vertexBuffer[2 * i + 1] = y;
    }
    
    self.currentPointNum += pointNumber;
    if (needRealloc) {
        [self removeBuffer];
        [self createBufferDynamic];
    }
    else {
        [self updateAttributeBuffer];
    }
    
    
    
}
- (void)removeAllPoints
{
    self.currentPointNum = 0;
    
}
@end
