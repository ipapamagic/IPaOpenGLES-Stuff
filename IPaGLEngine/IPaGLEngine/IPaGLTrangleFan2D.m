//
//  IPaGLTrangleFan2D.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/28.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLTrangleFan2D.h"
#import "IPaGLTrangleFan2DRenderer.h"
#import "IPaGLPath2D.h"
@implementation IPaGLTrangleFan2D
{
}
@dynamic renderer;
@dynamic matrix;
@dynamic path;
- (instancetype)initWithMaxPointsNumber:(GLint)maxPointsNumber renderer:(IPaGLTrangleFan2DRenderer*)renderer
{
    return [super initWithPath:[[IPaGLPath2D alloc] initWithMaxPointsNumber:maxPointsNumber] renderer:renderer];
}
- (instancetype)initWithPath:(IPaGLPath2D*)path renderer:(IPaGLTrangleFan2DRenderer*)renderer
{
    return [super initWithPath:path renderer:renderer];
}
-(void)dealloc
{

    
}

@end
