//
//  IPaGLPoints2D.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/22.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLPoints2D.h"
#import "IPaGLPoints2DRenderer.h"
#import "IPaGLPath2D.h"
@implementation IPaGLPoints2D
{
}
- (instancetype)initWithMaxPointsNumber:(GLint)maxPointsNumber renderer:(IPaGLPoints2DRenderer*)renderer
{
    return  [super initWithPath:[[IPaGLPath2D alloc] initWithMaxPointsNumber:maxPointsNumber] renderer:renderer];
}
- (instancetype)initWithPath:(IPaGLPath2D*)path renderer:(IPaGLPoints2DRenderer*)renderer
{
    return [super initWithPath:path renderer:renderer];
}
-(void)dealloc
{


}


@end
