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
@interface IPaGLPerspectiveSprite2D()
@property (nonatomic,strong) NSMutableArray *actions;
@end
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
- (GLKVector2)positionForCorner:(IPaGLPerspectiveSprite2DCorner)corner
{
    GLfloat *vertexAttr = self.vertexAttributes;
    GLint cornerOffset = corner*5;
    GLKVector2 position = GLKVector2Make(vertexAttr[cornerOffset], vertexAttr[cornerOffset+1]);
    GLKVector2 displaySize = self.renderer.displaySize;
    position.x = (position.x + 1) * displaySize.x * 0.5;
    position.y = (1 - position.y) * displaySize.y * 0.5;
    
    return position;
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
    vertexAttr[4] = vertexAttr[9] = vertexAttr[14] = vertexAttr[19] = 1;
    
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
    

    vertexAttr[7] = vertexAttr[17] = texCoordRatio.x;
    vertexAttr[13] = vertexAttr[18] = texCoordRatio.y;

    [self updateAttributeBuffer];
    
   
}

-(void)setTexture:(IPaGLTexture*)texture
{
    //may need to reset image Rect
    self.material.texture = texture;
    
}

- (void)render
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    NSUInteger index = 0;
    for (IPaGL2DAction *action in self.actions) {
        [action update];
        if ([action isComplete]) {
            [indexSet addIndex:index];
        }
        index++;
    }
    if ([indexSet count] > 0) {
        [self.actions removeObjectsAtIndexes:indexSet];
    }

    //    renderer.projectionMatrix = self.projectionMatrix;
    [self.renderer render:self];

    
}

- (GLKVector2)getUVOfPoint:(GLKVector2)point
{
    GLfloat *vertexAttr = self.vertexAttributes;
    GLKVector2 displaySize = self.renderer.displaySize;
    GLKVector2 displaySizeRatio =  GLKVector2Make(2/displaySize.x, 2/displaySize.y) ;
    
    GLKVector2 targetPoint = GLKVector2Make(-1 + point.x * displaySizeRatio.x,1 - point.y * displaySizeRatio.y);
    GLint blOffset = IPaGLPerspectiveSprite2DCornerBottomLeft * 5;
    GLint ulOffset = IPaGLPerspectiveSprite2DCornerUpperLeft * 5;
    GLint urOffset = IPaGLPerspectiveSprite2DCornerUpperRight * 5;
    GLint brOffset = IPaGLPerspectiveSprite2DCornerBottomRight * 5;
    GLKVector2 blPoint = GLKVector2Make(vertexAttr[blOffset], vertexAttr[blOffset+1]);
    GLKVector2 ulPoint = GLKVector2Make(vertexAttr[ulOffset], vertexAttr[ulOffset+1]);
    GLKVector2 brPoint = GLKVector2Make(vertexAttr[brOffset], vertexAttr[brOffset+1]);
    GLKVector2 urPoint = GLKVector2Make(vertexAttr[urOffset], vertexAttr[urOffset+1]);
    GLKVector2 crossPoint;

//    GLfloat m = (urPoint.y - blPoint.y ) / (urPoint.x - blPoint.x);
//    GLfloat m2 = (targetPoint.y - blPoint.y ) / (targetPoint.x - blPoint.x);
    GLKVector2 point1 = ulPoint;
    GLKVector2 point2 = urPoint;
    GLint offset1 = ulOffset;
    GLint offset2 = urOffset;
    BOOL result = [self crossPointOfLineStartP:blPoint endP:targetPoint Line2StartP:point1 end2P:point2 result:&crossPoint];
    
    if (!result) {
        point1 = urPoint;
        point2 = brPoint;
        offset1 = urOffset;
        offset2 = brOffset;
        [self crossPointOfLineStartP:blPoint endP:targetPoint Line2StartP:point1 end2P:point2 result:&crossPoint];
    }
    
    
    GLfloat ratio = GLKVector2Distance(crossPoint, point1) / GLKVector2Distance(point1, point2);
    GLKVector2 vector = GLKVector2Normalize(GLKVector2Subtract(crossPoint, point1));
    GLKVector2 vector2 = GLKVector2Normalize(GLKVector2Subtract(point2, point1));
    if (GLKVector2Length(GLKVector2Add(vector,vector2)) == 0)
    {
        ratio = -ratio;
    }
    
    GLfloat crossS = vertexAttr[offset1+2] + ratio * (vertexAttr[offset2+2] - vertexAttr[offset1+2]);
    GLfloat crossT = vertexAttr[offset1+3] + ratio * (vertexAttr[offset2+3] - vertexAttr[offset1+3]);
    GLfloat crossQ = vertexAttr[offset1+4] + ratio * (vertexAttr[offset2+4] - vertexAttr[offset1+4]);
    
    
    ratio = GLKVector2Distance(targetPoint, blPoint) / GLKVector2Distance(crossPoint, blPoint);
    vector = GLKVector2Normalize(GLKVector2Subtract(targetPoint, blPoint));
    vector2 = GLKVector2Normalize(GLKVector2Subtract(crossPoint, blPoint));
    if (GLKVector2Length(GLKVector2Add(vector,vector2)) == 0)
    {
        ratio = -ratio;
    }
    GLfloat targetS = vertexAttr[blOffset+2] + ratio * (crossS - vertexAttr[blOffset+2]);
    GLfloat targetT = vertexAttr[blOffset+3] + ratio * (crossT - vertexAttr[blOffset+3]);
    GLfloat targetQ = vertexAttr[blOffset+4] + ratio * (crossQ - vertexAttr[blOffset+4]);
    
    
    GLfloat u = targetS / targetQ;
    GLfloat v = targetT / targetQ;
    
    return GLKVector2Make(u, v);
    
    
}

- (BOOL)crossPointOfLineStartP:(GLKVector2)startP endP:(GLKVector2)endP Line2StartP:(GLKVector2)start2P end2P:(GLKVector2)end2P result:(GLKVector2*)resultPoint
{
    
    GLfloat m1 = (startP.x == endP.x)?0:(startP.y - endP.y) / (startP.x - endP.x);
    GLfloat m2 = (start2P.x == end2P.x)?0:(start2P.y - end2P.y) / (start2P.x - end2P.x);
    
    
    GLfloat c1 = endP.y - endP.x * m1;
    
    
    GLfloat c2 = end2P.y - end2P.x * m2;
    
    if (m2 == m1 && c1 != c2) {
        return NO;
    }
    *resultPoint = GLKVector2Make((c1-c2)/(m2-m1), (m1*c2-m2*c1) / (m1-m2));
    return YES;
}

- (NSMutableArray*)actions
{
    if (_actions == nil) {
        _actions = [@[] mutableCopy];
    }
    return _actions;
}

- (void)addAction:(IPaGL2DAction*)action
{
    action.target = self;
    [self.actions addObject:action];
}
- (GLKVector2)position
{
    return self.center;
}
- (void)setPosition:(GLKVector2)position
{
    [self setCenter:position];
}
@end
