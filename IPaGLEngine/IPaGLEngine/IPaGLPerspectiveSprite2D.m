//
//  IPaGLPerspectiveSprite2D.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/13.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLPerspectiveSprite2D.h"
#import "IPaGLSprite2DRenderer.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
#import "IPaGLRenderSource.h"
#import "IPaGLPerspectiveSprite2DRenderer.h"
@implementation IPaGLPerspectiveSprite2D
{
    IPaGLRenderSource *source;
}
@synthesize material = _material;
@synthesize matrix = _matrix;

-(id)initWithUIImage:(UIImage*)image withName:(NSString*)name renderer:(IPaGLPerspectiveSprite2DRenderer*) useRenderer
{
    self = [super init];
    source = [[IPaGLRenderSource alloc] init];
    GLKVector2 displaySize = useRenderer.displaySize;
    GLfloat VertexData[] = {
        //底
        0,displaySize.y ,0,0,1,
        displaySize.x ,displaySize.y,1,0,1,
        0,0,0,1,1,
        displaySize.x,0,1,1,1
    };
    source.vertexAttributes = malloc(sizeof(VertexData));
    memcpy(source.vertexAttributes, VertexData, sizeof(VertexData));
    source.vertexAttributeCount = 4;
    source.attrHasPosZ = NO;
    source.attrHasNormal = NO;
    source.attrHasTexCoords3D = YES;
    [source createBufferDynamic];
    self.material = [[IPaGLMaterial alloc] init];
    self.matrix = GLKMatrix4Identity;


    self.material.texture = [IPaGLTexture textureFromImage:image withName:name];
    self.renderer = useRenderer;
    GLfloat *vertexAttr = source.vertexAttributes;
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
    
    if (!(texCoordRatio.x == 1 && texCoordRatio.y == 1)) {
        vertexAttr[2] = vertexAttr[12] = 0;
        vertexAttr[3] = vertexAttr[8] = 0;
        vertexAttr[7] = vertexAttr[17] = texCoordRatio.x;
        vertexAttr[13] = vertexAttr[18] = texCoordRatio.y;
        [source updateAttributeBuffer];
        
    }
    self.center = GLKVector2Make(displaySize.x / 2, displaySize.y / 2);
    return self;
}
- (void)setImage:(UIImage*)image withName:(NSString*)name
{
    self.material.texture = [IPaGLTexture textureFromImage:image withName:name];
}
- (void)setImage:(UIImage*)image
{
    [self setImage:image withName:[image description]];
}

-(void)setTextureRect:(GLKVector4)rect
{
    GLKVector2 imgSize = self.material.texture.imageSize;
    
    //set image rect
    GLfloat *vertexAttr = source.vertexAttributes;
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
    vertexAttr[2] = vertexAttr[12] = rect.x / imgSize.x * texCoordRatio.x;
    vertexAttr[3] = vertexAttr[8] = (1 - ((rect.y + rect.w) / imgSize.y))  * texCoordRatio.y;
    vertexAttr[7] = vertexAttr[17] = (rect.x + rect.z) / imgSize.x  * texCoordRatio.x;
    vertexAttr[13] = vertexAttr[18] = (1 - (rect.y / imgSize.y)) * texCoordRatio.y;
    
    [source updateAttributeBuffer];
    
}
-(void)dealloc
{
    source = nil;
    [self.material releaseResource];
    self.material = nil;
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
- (void)setCorner:(IPaGLPerspectiveSprite2DCorner)corner position:(GLKVector2)position;
{

    GLfloat *vertexAttr = source.vertexAttributes;
    GLint cornerOffset = corner*5;
    vertexAttr[cornerOffset] = position.x;
    vertexAttr[cornerOffset + 1] = position.y;

    
//
    GLint offset = IPaGLPerspectiveSprite2DCornerUpperLeft * 5;
    GLKVector2 firstPos = GLKVector2Make(vertexAttr[offset], vertexAttr[offset+1]);
    offset = IPaGLPerspectiveSprite2DCornerBottomRight * 5;
    GLKVector2 thirdPos = GLKVector2Make(vertexAttr[offset], vertexAttr[offset+1]);
    GLfloat m1 = (thirdPos.y - firstPos.y) / (thirdPos.x - firstPos.x);
    GLfloat c1 = firstPos.y - firstPos.x * m1;
    
    offset = IPaGLPerspectiveSprite2DCornerUpperRight * 5;
    GLKVector2 secondPos = GLKVector2Make(vertexAttr[offset], vertexAttr[offset+1]);
    offset = IPaGLPerspectiveSprite2DCornerBottomLeft * 5;
    GLKVector2 fourthPos = GLKVector2Make(vertexAttr[offset], vertexAttr[offset+1]);
    GLfloat m2 = (fourthPos.y - secondPos.y) / (fourthPos.x - secondPos.x);
    GLfloat c2 = secondPos.y - secondPos.x * m2;
    
    _center = GLKVector2Make((c1-c2)/(m2-m1), (m1*c2-m2*c1) / (m1-m2));
    //it's formular.....
    // (uvqi = float3(ui,vi,1) * (di+d(i+2)) / d(i+2) )
    
    
    GLfloat firstLen = GLKVector2Distance(firstPos, _center);
    GLfloat secondLen = GLKVector2Distance(secondPos, _center);
    GLfloat thirdLen = GLKVector2Distance(thirdPos, _center);
    GLfloat fourthLen = GLKVector2Distance(fourthPos, _center);

    GLfloat d = (firstLen + thirdLen) / thirdLen;
    vertexAttr[IPaGLPerspectiveSprite2DCornerUpperLeft * 5 + 3] = d;
    vertexAttr[IPaGLPerspectiveSprite2DCornerUpperLeft * 5 + 4] = d;
    
    d = (secondLen + fourthLen) / fourthLen;
    vertexAttr[IPaGLPerspectiveSprite2DCornerUpperRight * 5 + 2] = d;
    vertexAttr[IPaGLPerspectiveSprite2DCornerUpperRight * 5 + 3] = d;
    vertexAttr[IPaGLPerspectiveSprite2DCornerUpperRight * 5 + 4] = d;
    
    d = (thirdLen + firstLen) / firstLen;
    vertexAttr[IPaGLPerspectiveSprite2DCornerBottomRight * 5 + 2] = d;
    vertexAttr[IPaGLPerspectiveSprite2DCornerBottomRight * 5 + 4] = d;
    
    
    d = (fourthLen + secondLen) / secondLen;
    vertexAttr[IPaGLPerspectiveSprite2DCornerBottomLeft * 5 + 4] = d;
    
    
    
    
    
    [source updateAttributeBuffer];
    
    
}
-(void)setPosition:(GLKVector2)position size:(GLKVector2)size
{
    GLfloat *vertexAttr = source.vertexAttributes;
    vertexAttr[0] = vertexAttr[10] = position.x;
    vertexAttr[1] = vertexAttr[6] = position.y + size.y;
    vertexAttr[5] = vertexAttr[15] = position.x + size.x;
    vertexAttr[11] = vertexAttr[16] = position.y ;
    [source updateAttributeBuffer];
    
   
}

-(void)setTexture:(IPaGLTexture*)texture
{
    //may need to reset image Rect
    self.material.texture = texture;
    
}

- (void)render
{
    //    renderer.projectionMatrix = self.projectionMatrix;
    [self.renderer prepareToRenderSprite2D:self];
    [source renderWithRenderer:self.renderer];
    
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
@end
