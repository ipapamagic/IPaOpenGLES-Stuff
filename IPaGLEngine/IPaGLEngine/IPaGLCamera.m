//
//  IPaGLCamera.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLCamera.h"
#import "IPaGLEntity.h"
#import "IPaGLEntityRenderer.h"
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
- (GLKMatrix4)viewMatrix
{
    bool isInvertible;
    return GLKMatrix4Invert(self.matrix, &isInvertible);
}
- (GLKMatrix4)viewProjectionMatrix
{
    return GLKMatrix4Multiply(self.projectionMatrix, self.viewMatrix);
}
- (void)renderIPaGLEntity:(IPaGLEntity*)entity
{
    [entity.renderer renderEntity:entity withCamera:self];


}
@end
