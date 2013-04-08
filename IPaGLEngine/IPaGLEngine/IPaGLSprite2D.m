//
//  IPaGLSprite2D.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/7.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLSprite2D.h"
#import "IPaGLRenderer.h"
#import "IPaGLSprite2DRenderer.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
#import "IPaGLRenderSource.h"
@interface IPaGLSprite2D ()
@end
@implementation IPaGLSprite2D
{
    IPaGLRenderSource *source;
}
-(id)init
{
    if (self = [super init]) {
        source = [[IPaGLRenderSource alloc] init];
        GLfloat VertexData[] = {
            //底
            -1,-1,0,0,
            1,-1,1,0,
            -1,1,0,1,
            1,1,1,1,
        };
        source.vertexAttributes = malloc(sizeof(VertexData));
        memcpy(source.vertexAttributes, VertexData, sizeof(VertexData));
        source.vertexAttributeCount = 4;
        source.attrHasPosZ = NO;
        source.attrHasNormal = NO;
        source.attrHasTexCoords = YES;
        [source createBuffer];
        self.material = [[IPaGLMaterial alloc] init];
        self.matrix = GLKMatrix4Identity;
    }
    return self;
}
-(id)initWithUIImage:(UIImage*)image withName:(NSString*)name
{
    self = [self init];
    
    self.material.texture = [IPaGLTexture textureFromImage:image withName:name];
    
    [self setPosition:GLKVector2Make(0, 0) size:GLKVector2Make(image.size.width, image.size.height)];
    
    
    GLfloat *vertexAttr = source.vertexAttributes;
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
//    vertexAttr[2] = vertexAttr[10] = 0;
//    vertexAttr[3] = vertexAttr[7] = 0;
    vertexAttr[6] = vertexAttr[14] = texCoordRatio.x;
    vertexAttr[11] = vertexAttr[15] = texCoordRatio.y;
    [source updateAttributeBuffer];
    return self;
}
-(void)setImageRect:(GLKVector4)rect
{
    GLKVector2 imgSize = self.material.texture.imageSize;

    //set image rect
    GLfloat *vertexAttr = source.vertexAttributes;
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
    vertexAttr[2] = vertexAttr[10] = rect.x / imgSize.x * texCoordRatio.x;
    vertexAttr[3] = vertexAttr[7] = (1 - ((rect.y + rect.w) / imgSize.y))  * texCoordRatio.y;
    vertexAttr[6] = vertexAttr[14] = (rect.x + rect.z) / imgSize.x  * texCoordRatio.x;
    vertexAttr[11] = vertexAttr[15] = (1 - (rect.y / imgSize.y)) * texCoordRatio.y;
    [source updateAttributeBuffer];
    
}
-(void)dealloc
{
    source = nil;
    [self.material releaseResource];
}
-(void)setPosition:(GLKVector2)position
{
    _position = position;
    [self refreshMatrix];    
}
-(void)setSize:(GLKVector2)size
{
    _size = size;
    [self refreshMatrix];
}
-(void)setPosition:(GLKVector2)position size:(GLKVector2)size
{
    _position = position;
    _size = size;
    [self refreshMatrix];
}
-(void)refreshMatrix
{
 
    GLKVector2 displaySizeRatio = self.renderer.displaySizeRatio;
//    
//    -1,-1,0,0,
//    1,-1,1,0,
//    -1,1,0,1,
//    1,1,1,1,
    GLfloat *vertexAttr = source.vertexAttributes;
    
    vertexAttr[0] = vertexAttr[8] = -1 + (self.position.x * displaySizeRatio.x * 2);
    vertexAttr[1] = vertexAttr[5] = 1 - ((self.position.y + self.size.y)* displaySizeRatio.y * 2);
    vertexAttr[4] = vertexAttr[12] = -1 + (self.position.x + self.size.x) * displaySizeRatio.x * 2;
    vertexAttr[9] = vertexAttr[13] = 1 - (self.position.y * displaySizeRatio.y * 2);
    [source updateAttributeBuffer];
    
//    _matrix = GLKMatrix4MakeTranslation(-1 + (self.size.x + self.position.x * 2) * displaySizeRatio.x,1 - (self.size.y + self.position.y * 2) * displaySizeRatio.y, 0);
//    
//    _matrix = GLKMatrix4Scale(_matrix, self.size.x * displaySizeRatio.x, self.size.y * displaySizeRatio.y, 1);
//    
}

-(void)setTexture:(IPaGLTexture*)texture
{
    //may need to reset image Rect 
    self.material.texture = texture;
    
}
-(void)render
{
    [self.renderer prepareToRenderWithMatrix:self.matrix];
    [self.renderer prepareToRenderWithMaterial:self.material];
    
    
    [source renderWithRenderer:self.renderer];
    

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
@end
