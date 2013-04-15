//
//  IPaGLSprite2DRenderer.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/8.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//


#import "IPaGLSprite2DRenderer.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
@implementation IPaGLKitSprite2DRenderer
{
    
    GLKVector2 displaySizeRatio;
}
-(id)init
{
    if (self = [super init]) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        self.displaySize = GLKVector2Make(size.width, size.height);
        
    }
    return self;
}
-(id)initWithDisplaySize:(GLKVector2)displaySize
{
    if (self = [super init]) {
        self.displaySize = displaySize;
    }
    return self;
}
-(GLKVector2)displaySizeRatio
{
    return displaySizeRatio;
}
-(void)setDisplaySize:(GLKVector2)displaySize
{
    _displaySize = displaySize;
    displaySizeRatio = GLKVector2Make(1 / displaySize.x, 1 / displaySize.y);
}
-(void)prepareToDraw
{
    [super prepareToDraw];
    self.effect.transform.projectionMatrix = GLKMatrix4Identity;
    self.effect.transform.modelviewMatrix = GLKMatrix4Identity;
}
//-(void)prepareToRenderWithMatrix:(GLKMatrix4)matrix
//{
//    self.effect.transform.projectionMatrix = GLKMatrix4Identity;
//    self.effect.transform.modelviewMatrix = matrix;
//}


@end

@implementation IPaGLShaderSprite2DRenderer
{
    GLKVector2 displaySizeRatio;
}
-(id)init
{
    if (self = [super init]) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        self.displaySize = GLKVector2Make(size.width, size.height);
        
    }
    return self;
}
-(id)initWithDisplaySize:(GLKVector2)displaySize
{
    if (self = [super init]) {
        self.displaySize = displaySize;
    }
    return self;
}
-(void)setDisplaySize:(GLKVector2)displaySize
{
    _displaySize = displaySize;
    displaySizeRatio = GLKVector2Make(1 / displaySize.x, 1 / displaySize.y);
}
//-(void)prepareToRenderWithMatrix:(GLKMatrix4)matrix
//{
//    NSAssert(NO, @"%@ need to over override setModelViewMatrix",[self class]);
//}
-(GLKVector2)displaySizeRatio
{
    return displaySizeRatio;
}



@end
