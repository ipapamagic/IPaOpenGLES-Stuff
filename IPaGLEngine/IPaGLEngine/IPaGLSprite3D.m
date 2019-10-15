//
//  IPaGLSprite3D.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/30.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLSprite3D.h"
#import "IPaGLRenderSource.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
@implementation IPaGLSprite3D
@dynamic renderer;
- (instancetype)initWithRenderer:(IPaGLSprite3DRenderer*)useRenderer
{
    self = [super init];
    
    GLfloat VertexData[] = {
        //底
        -1,-1,0,0,
        1,-1,1,0,
        -1,1,0,1,
        1,1,1,1,
    };
    //    GLKVector2 displaySize = useRenderer.displaySize;
    //    GLfloat VertexData[] = {
    //        //底
    //        0,displaySize.y ,0,0,
    //        displaySize.x ,displaySize.y,1,0,
    //        0,0,0,1,
    //        displaySize.x,0,1,1,
    //    };
    self.source = [[IPaGLRenderSource alloc] init];
    
    self.source.vertexAttributes = malloc(sizeof(VertexData));
    memcpy(self.source.vertexAttributes, VertexData, sizeof(VertexData));
    self.source.vertexAttributeCount = 4;
    self.source.attrHasPosZ = NO;
    self.source.attrHasNormal = NO;
    self.source.attrHasTexCoords = YES;
    self.renderer = useRenderer;
    self.material = [[IPaGLMaterial alloc] init];
    self.matrix = GLKMatrix4Identity;
    return self;
}
- (instancetype)initWithTexture:(IPaGLTexture*)texture renderer:(IPaGLSprite3DRenderer*) useRenderer
{
    self = [self initWithRenderer:useRenderer];
    
    [self setTexture:texture update:NO];
    [self.source createBufferDynamic];
    return self;
}
- (instancetype)initWithUIImage:(UIImage*)image withName:(NSString*)name renderer:(IPaGLSprite3DRenderer*) useRenderer
{
    self = [self initWithRenderer:useRenderer];
    
    [self setTexture:[IPaGLTexture textureFromImage:image withName:name] update:NO];
    
    [self.source createBufferDynamic];
    return self;
}
-(void)setTextureRect:(GLKVector4)rect
{
    GLKVector2 imgSize = self.material.texture.imageSize;
    
    //set image rect
    GLfloat *vertexAttr = self.source.vertexAttributes;
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
    vertexAttr[2] = vertexAttr[10] = rect.x / imgSize.x * texCoordRatio.x;
    vertexAttr[3] = vertexAttr[7] = (1 - ((rect.y + rect.w) / imgSize.y))  * texCoordRatio.y;
    vertexAttr[6] = vertexAttr[14] = (rect.x + rect.z) / imgSize.x  * texCoordRatio.x;
    vertexAttr[11] = vertexAttr[15] = (1 - (rect.y / imgSize.y)) * texCoordRatio.y;
    [self.source updateAttributeBuffer];
    
}
- (void)setImage:(UIImage*)image withName:(NSString*)name
{
    self.material.texture = [IPaGLTexture textureFromImage:image withName:name];
}
- (void)setImage:(UIImage*)image
{
    [self setImage:image withName:[image description]];
}
-(void)dealloc
{
    [self.material releaseResource];
}
-(CGFloat)alpha
{
    if (self.material.constantColor == nil) {
        return 1;
    }
    CGFloat constRed,constGreen,constBlue,constAlpha;
    
    [self.material.constantColor getRed:&constRed green:&constGreen blue:&constBlue alpha:&constAlpha];
    return constAlpha;
}
-(void)setAlpha:(CGFloat)alpha
{
    if (self.material.constantColor == nil) {
        self.material.constantColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
    }
    else
    {
        self.material.constantColor = [self.material.constantColor colorWithAlphaComponent:alpha];
    }
}
-(void)setSize:(GLKVector2)size
{
    _size = size;
    GLfloat *vertexAttr = self.source.vertexAttributes;
    
    GLfloat width = size.x * .5;
    GLfloat height = size.y * .5;
    vertexAttr[0] = vertexAttr[8] = -width;
    vertexAttr[4] = vertexAttr[12] = width;
    vertexAttr[1] = vertexAttr[5] = -height;
    vertexAttr[9] = vertexAttr[13] = height;
    [self.source updateAttributeBuffer];
}

-(void)setTexture:(IPaGLTexture*)texture update:(BOOL)update
{
    //may need to reset image Rect
    self.material.texture = texture;
    GLfloat *vertexAttr = self.source.vertexAttributes;
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
    
    
    vertexAttr[2] = vertexAttr[10] = 0;
    vertexAttr[3] = vertexAttr[7] = 0;
    vertexAttr[6] = vertexAttr[14] = texCoordRatio.x;
    vertexAttr[11] = vertexAttr[15] = texCoordRatio.y;
    //        [source updateAttributeBuffer];
    
    if (update) {
        [self.source updateAttributeBuffer];
    }
}
-(void)setTexture:(IPaGLTexture*)texture
{
    [self setTexture:texture update:YES];
}
@end
