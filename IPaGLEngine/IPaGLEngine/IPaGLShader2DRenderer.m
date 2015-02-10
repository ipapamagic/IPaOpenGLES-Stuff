//
//  IPaGLShader2DRenderer.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/22.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLShader2DRenderer.h"

@implementation IPaGLShader2DRenderer
-(id)init
{
    if (self = [super init]) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        self.displaySize = GLKVector2Make(size.width, size.height);
        self.projectionMatrix = GLKMatrix4MakeOrtho(-1, 1, -1, 1, 0, 0.3);
    }
    return self;
}
-(id)initWithDisplaySize:(GLKVector2)displaySize
{
    if (self = [super init]) {
        self.displaySize = displaySize;
        self.projectionMatrix = GLKMatrix4MakeOrtho(-1, 1, -1, 1, 0, 0.3);
    }
    return self;
}
- (void)render:(IPaGLPath2DContainer *)pathContainer
{
    
}
//-(void)setDisplaySize:(GLKVector2)displaySize
//{
//    _displaySize = displaySize;
//    
//    
//    GLKMatrix4 matrix = GLKMatrix4MakeScale( 2/displaySize.x, -2/displaySize.y, 1);
//    matrix = GLKMatrix4Translate(matrix, -displaySize.x * .5, -displaySize.y * .5, 0);
//    
//    self.projectionMatrix = matrix;
//}
@end
