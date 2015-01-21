//
//  IPaGLCamera.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLCamera.h"
#import "IPaGLEntity.h"
#import "IPaGLRenderer.h"
@interface IPaGLCamera()
@property (nonatomic,readonly) GLKMatrix4 inverseMatrix;
@end
@implementation IPaGLCamera
{
}
- (instancetype) init
{
    self = [super init];
    self.matrix = GLKMatrix4Identity;
    
    return self;
}
- (instancetype)initWithFovyRadians:(GLfloat)fovyRadians displaySize:(CGSize)displaySize nearZ:(GLfloat)nearZ farZ:(GLfloat)farZ
{
    self = [self init];
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fovyRadians), displaySize.width / displaySize.height, nearZ, farZ);
    
    return self;
}
- (GLKMatrix4)inverseMatrix
{
    bool isInvertible;
    return GLKMatrix4Invert(self.matrix, &isInvertible);
}
- (void)renderIPaGLEntity:(IPaGLEntity*)entity
{
    
    [entity.renderer setProjectionMatrix:self.projectionMatrix];
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(entity.matrix, self.matrix);

}
@end
