//
//  IPaGLSprite2DRenderer.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/8.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//


#import "IPaGLSprite2DRenderer.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
@implementation IPaGLKitSprite2DRenderer
{
    
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
    GLKMatrix4 matrix = GLKMatrix4MakeTranslation(-1, 1, 0);
    matrix = GLKMatrix4Scale(matrix, 2/displaySize.x, 2/displaySize.y, 1);
    
    
    self.projectionMatrix = matrix;

}


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
    GLKMatrix4 matrix = GLKMatrix4MakeTranslation(-1, 1, 0);
    matrix = GLKMatrix4Scale(matrix, 2/displaySize.x, 2/displaySize.y, 1);
    
    
    self.projectionMatrix = matrix;
    
}



@end
