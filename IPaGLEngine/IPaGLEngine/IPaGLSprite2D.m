//
//  IPaGLSprite2D.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/7.
//  Copyright (c) 2013 IPaPa. All rights reserved.
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
//    GLKMatrix4 matrix;
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
        [source createBufferStatic];
        self.material = [[IPaGLMaterial alloc] init];
//        matrix = GLKMatrix4Identity;
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
    
    if (!(texCoordRatio.x == 1 && texCoordRatio.y == 1)) {
        vertexAttr[2] = vertexAttr[10] = 0;
        vertexAttr[3] = vertexAttr[7] = 0;
        vertexAttr[6] = vertexAttr[14] = texCoordRatio.x;
        vertexAttr[11] = vertexAttr[15] = texCoordRatio.y;
        [source updateAttributeBuffer];

    }
    return self;
}
-(void)setTextureRect:(GLKVector4)rect
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
-(void)setPosition:(GLKVector2)position
{
    _position = position;
    [self updateMatrix];    
}
-(GLKVector2)center
{
    return GLKVector2Make(self.position.x + self.size.x * 0.5, self.position.y + self.size.y * 0.5);
}
-(void)setCenter:(GLKVector2)center
{
    self.position = GLKVector2Make(center.x - self.size.x * 0.5, center.y - self.size.y * 0.5);
}
-(void)setSize:(GLKVector2)size
{
    _size = size;
    [self updateMatrix];
}
-(void)setPosition:(GLKVector2)position size:(GLKVector2)size
{
    _position = position;
    _size = size;
    [self updateMatrix];
}
-(void)setCenter:(GLKVector2)center size:(GLKVector2)size
{
    _size = size;
    _position = GLKVector2Make(center.x - self.size.x * 0.5, center.y - self.size.y * 0.5);
    [self updateMatrix];
}
-(void)updateMatrix
{
    
//    GLKVector2 displaySizeRatio = self.renderer.displaySizeRatio;
//    GLfloat *vertexAttr = source.vertexAttributes;
//
//    vertexAttr[0] = vertexAttr[8] = -1 + (self.position.x * displaySizeRatio.x * 2);
//    vertexAttr[1] = vertexAttr[5] = 1 - ((self.position.y + self.size.y)* displaySizeRatio.y * 2);
//    vertexAttr[4] = vertexAttr[12] = -1 + (self.position.x + self.size.x) * displaySizeRatio.x * 2;
//    vertexAttr[9] = vertexAttr[13] = 1 - (self.position.y * displaySizeRatio.y * 2);
//    [source updateAttributeBuffer];
    

    self.matrix = GLKMatrix4MakeTranslation(self.size.x * 0.5 + self.position.x, -self.size.y * 0.5 - self.position.y, 0);
    self.matrix = GLKMatrix4Scale(self.matrix,self.size.x * 0.5, self.size.y * 0.5, 1);

//    self.matrix = GLKMatrix4Scale(self.matrix, self.size.x, -self.size.y, 1);
    //self.matrix = GLKMatrix4Translate(self.matrix,self.position.x,self.position.y,0);

    
}


-(void)setTexture:(IPaGLTexture*)texture
{
    //may need to reset image Rect 
    self.material.texture = texture;
    
}
-(void)renderWithRenderer:(IPaGLRenderer <IPaGLSprite2DRenderer> *)renderer
{
//    renderer.projectionMatrix = self.projectionMatrix;
    renderer.modelMatrix = self.matrix;
    
   
    [renderer prepareToRenderWithMaterial:self.material];
    
    
    [source renderWithRenderer:renderer];
    

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
@end
