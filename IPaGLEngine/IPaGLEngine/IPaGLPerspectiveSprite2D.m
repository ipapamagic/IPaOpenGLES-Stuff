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
#import "IPaGLPerspectiveSprite2DRenderer.h"
@implementation IPaGLPerspectiveSprite2D
{
}
@synthesize material = _material;
@synthesize matrix = _matrix;

-(id)initWithUIImage:(UIImage*)image withName:(NSString*)name renderer:(IPaGLPerspectiveSprite2DRenderer*) useRenderer
{
    self = [super init];
    GLKVector2 displaySize = useRenderer.displaySize;
//    GLfloat VertexData[] = {
//        //底
//        0,displaySize.y ,0,0,1,
//        displaySize.x ,displaySize.y,1,0,1,
//        0,0,0,1,1,
//        displaySize.x,0,1,1,1
//    };
    GLfloat VertexData[] = {
        //底
        -1,-1,0,0,1,
        1,-1,1,0,1,
        -1,1,0,1,1,
        1,1,1,1,1
    };
    
    self.vertexAttributes = malloc(sizeof(VertexData));
    memcpy(self.vertexAttributes, VertexData, sizeof(VertexData));
    self.vertexAttributeCount = 4;
    self.attrHasPosZ = NO;
    self.attrHasNormal = NO;
    self.attrHasTexCoords3D = YES;
    [self createBufferDynamic];
    self.material = [[IPaGLMaterial alloc] init];
    self.matrix = GLKMatrix4Identity;
    
    self.material.texture = [IPaGLTexture textureFromImage:image withName:name];
    self.renderer = useRenderer;
    GLfloat *vertexAttr = self.vertexAttributes;
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
    
    if (!(texCoordRatio.x == 1 && texCoordRatio.y == 1)) {
        vertexAttr[2] = vertexAttr[12] = 0;
        vertexAttr[3] = vertexAttr[8] = 0;
        vertexAttr[7] = vertexAttr[17] = texCoordRatio.x;
        vertexAttr[13] = vertexAttr[18] = texCoordRatio.y;
        [self updateAttributeBuffer];
        
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

//-(void)setTextureRect:(GLKVector4)rect
//{
//    GLKVector2 imgSize = self.material.texture.imageSize;
//    
//    //set image rect
//    GLfloat *vertexAttr = self.vertexAttributes;
//    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
//    vertexAttr[2] = vertexAttr[12] = rect.x / imgSize.x * texCoordRatio.x;
//    vertexAttr[3] = vertexAttr[8] = (1 - ((rect.y + rect.w) / imgSize.y))  * texCoordRatio.y;
//    vertexAttr[7] = vertexAttr[17] = (rect.x + rect.z) / imgSize.x  * texCoordRatio.x;
//    vertexAttr[13] = vertexAttr[18] = (1 - (rect.y / imgSize.y)) * texCoordRatio.y;
//    
//    [self updateAttributeBuffer];
//    
//}
-(void)dealloc
{
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

    GLfloat *vertexAttr = self.vertexAttributes;
    GLint cornerOffset = corner*5;
    GLKVector2 displaySize = self.renderer.displaySize;
    GLKVector2 displaySizeRatio =  GLKVector2Make(2/displaySize.x, 2/displaySize.y) ;
    vertexAttr[cornerOffset] = -1 + position.x * displaySizeRatio.x;
    vertexAttr[cornerOffset + 1] = 1 - (position.y * displaySizeRatio.y);

    
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
    GLKVector2 c = GLKVector2Make((c1-c2)/(m2-m1), (m1*c2-m2*c1) / (m1-m2));
    _center.x = (c.x + 1) * displaySize.x * .5;
    _center.y = (1 - c.y) * displaySize.y * .5;
    //it's formula.....
    // (uvqi = float3(ui,vi,1) * (di+d(i+2)) / d(i+2) )
    //http://www.reedbeta.com/blog/2012/05/26/quadrilateral-interpolation-part-1/
    
    GLfloat firstLen = GLKVector2Distance(firstPos, c);
    GLfloat secondLen = GLKVector2Distance(secondPos, c);
    GLfloat thirdLen = GLKVector2Distance(thirdPos, c);
    GLfloat fourthLen = GLKVector2Distance(fourthPos, c);

    GLfloat d = (firstLen + thirdLen) / thirdLen;
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
    
    
    vertexAttr[IPaGLPerspectiveSprite2DCornerUpperLeft * 5 + 3] = d * texCoordRatio.y;
    vertexAttr[IPaGLPerspectiveSprite2DCornerUpperLeft * 5 + 4] = d;
    
    d = (secondLen + fourthLen) / fourthLen;
    vertexAttr[IPaGLPerspectiveSprite2DCornerUpperRight * 5 + 2] = d * texCoordRatio.x;
    vertexAttr[IPaGLPerspectiveSprite2DCornerUpperRight * 5 + 3] = d * texCoordRatio.y;
    vertexAttr[IPaGLPerspectiveSprite2DCornerUpperRight * 5 + 4] = d;
    
    d = (thirdLen + firstLen) / firstLen;
    vertexAttr[IPaGLPerspectiveSprite2DCornerBottomRight * 5 + 2] = d * texCoordRatio.x;
    vertexAttr[IPaGLPerspectiveSprite2DCornerBottomRight * 5 + 4] = d;
    
    
    d = (fourthLen + secondLen) / secondLen;
    vertexAttr[IPaGLPerspectiveSprite2DCornerBottomLeft * 5 + 4] = d;
    
    
    [self updateAttributeBuffer];
    
    
}
-(void)setPosition:(GLKVector2)position size:(GLKVector2)size
{
    GLfloat *vertexAttr = self.vertexAttributes;
    GLKVector2 displaySize = self.renderer.displaySize;
    GLKVector2 displaySizeRatio =  GLKVector2Make(2/displaySize.x, 2/displaySize.y) ;
    vertexAttr[0] = vertexAttr[10] = -1 + position.x * displaySizeRatio.x;
    vertexAttr[1] = vertexAttr[6] = 1 - (position.y + size.y) * displaySizeRatio.y;
    vertexAttr[5] = vertexAttr[15] = -1 + (position.x + size.x) * displaySizeRatio.x;
    vertexAttr[11] = vertexAttr[16] = 1 - position.y * displaySizeRatio.y ;

    vertexAttr[2] = vertexAttr[3] = vertexAttr[8] = vertexAttr[12] = 0;
    vertexAttr[4] = vertexAttr[7] = vertexAttr[9] = vertexAttr[13] = vertexAttr[14] = vertexAttr[17] = vertexAttr[18] = vertexAttr[19] = 1;
    
    [self updateAttributeBuffer];
    
   
}

-(void)setTexture:(IPaGLTexture*)texture
{
    //may need to reset image Rect
    self.material.texture = texture;
    
}

- (void)render
{
    //    renderer.projectionMatrix = self.projectionMatrix;
    [self.renderer render:self];

    
}

- (GLKVector2)getUVOfPoint:(GLKVector2)point
{
    GLfloat *vertexAttr = self.vertexAttributes;
    GLKVector2 target = GLKVector2Make( point.x,point.y);
    GLint blOffset = IPaGLPerspectiveSprite2DCornerBottomLeft * 5;
    GLKVector2 origin = GLKVector2Make(vertexAttr[blOffset], vertexAttr[blOffset+1]);

    GLfloat m1 = (target.y - origin.y) / (target.x - origin.x);
    GLfloat c1 = origin.y - origin.x * m1;
    
    GLint ulOffset = IPaGLPerspectiveSprite2DCornerUpperLeft * 5;
    GLKVector2 luPos = GLKVector2Make(vertexAttr[ulOffset], vertexAttr[ulOffset+1]);
    GLint ruOffset = IPaGLPerspectiveSprite2DCornerUpperRight * 5;
    GLKVector2 ruPos = GLKVector2Make(vertexAttr[ruOffset], vertexAttr[ruOffset+1]);
    GLfloat m2 = (ruPos.y - luPos.y) / (ruPos.x - luPos.x);
    GLfloat c2 = ruPos.y - ruPos.x * m2;
    
    GLKVector2 crossPoint = GLKVector2Make((c1-c2)/(m2-m1), (m1*c2-m2*c1) / (m1-m2));
    
    GLfloat ratio = GLKVector2Distance(crossPoint, luPos) / GLKVector2Distance(luPos, ruPos);
    
    
    
    GLfloat crossS = vertexAttr[ulOffset+2] + ratio * (vertexAttr[ruOffset+2] - vertexAttr[ulOffset+2]);
    GLfloat crossT = vertexAttr[ulOffset+3] + ratio * (vertexAttr[ruOffset+3] - vertexAttr[ulOffset+3]);
    GLfloat crossQ = vertexAttr[ulOffset+4] + ratio * (vertexAttr[ruOffset+4] - vertexAttr[ulOffset+4]);
    
    
     ratio = GLKVector2Distance(target, origin) / GLKVector2Distance(crossPoint, origin);
    
    GLfloat targetS = vertexAttr[blOffset+2] + ratio * (crossS - vertexAttr[blOffset+2]);
    GLfloat targetT = vertexAttr[blOffset+3] + ratio * (crossT - vertexAttr[blOffset+3]);
    GLfloat targetQ = vertexAttr[blOffset+4] + ratio * (crossQ - vertexAttr[blOffset+4]);
    
    GLfloat u = targetS / targetQ;
    GLfloat v = targetT / targetQ;
    
    return GLKVector2Make(u, v);
    
    
}
@end
