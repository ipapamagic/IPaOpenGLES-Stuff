//
//  IPaGLSprite2D.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/7.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "IPaGLSprite2D.h"
#import "IPaGLSprite2DRenderer.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
@interface IPaGLSprite2D ()
@property (nonatomic,strong) NSMutableArray *actions;
@end
@implementation IPaGLSprite2D
{
//    GLKMatrix4 matrix;
}
@synthesize size = _size;
@synthesize origin = _origin;
//-(id)init
//{
//    return nil;
//}
- (instancetype)initWithRenderer:(IPaGLSprite2DRenderer*)useRenderer
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
//    self.projectMatrix = GLKMatrix4MakeOrtho(-1, 1, -1, 1, 0, 1);
    
    self.vertexAttributes = malloc(sizeof(VertexData));
    memcpy(self.vertexAttributes, VertexData, sizeof(VertexData));
    self.vertexAttributeCount = 4;
    self.attrHasPosZ = NO;
    self.attrHasNormal = NO;
    self.attrHasTexCoords = YES;
    self.renderer = useRenderer;
    self.material = [[IPaGLMaterial alloc] init];
    self.matrix = GLKMatrix4Identity;
    return self;
}
- (instancetype)initWithTexture:(IPaGLTexture*)texture renderer:(IPaGLSprite2DRenderer*) useRenderer
{
    self = [self initWithRenderer:useRenderer];
    
    
    [self setTexture:texture update:NO];
    [self createBufferDynamic];
    return self;
}
- (instancetype)initWithUIImage:(UIImage*)image withName:(NSString*)name renderer:(IPaGLSprite2DRenderer*) useRenderer
{
    self = [self initWithRenderer:useRenderer];

    [self setTexture:[IPaGLTexture textureFromImage:image withName:name] update:NO];
    
    [self createBufferDynamic];
    return self;
}
-(void)setTextureRect:(GLKVector4)rect
{
    GLKVector2 imgSize = self.material.texture.imageSize;

    //set image rect
    GLfloat *vertexAttr = self.vertexAttributes;
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
    vertexAttr[2] = vertexAttr[10] = rect.x / imgSize.x * texCoordRatio.x;
    vertexAttr[3] = vertexAttr[7] = (1 - ((rect.y + rect.w) / imgSize.y))  * texCoordRatio.y;
    vertexAttr[6] = vertexAttr[14] = (rect.x + rect.z) / imgSize.x  * texCoordRatio.x;
    vertexAttr[11] = vertexAttr[15] = (1 - (rect.y / imgSize.y)) * texCoordRatio.y;
    [self updateAttributeBuffer];
    
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
- (void)setOrigin:(GLKVector2)origin
{
    _origin = origin;
    [self updateSourceAttributes];
}
-(void)setPosition:(GLKVector2)position
{
    [self setCenter:position];
}
- (GLKVector2)position
{
    return self.center;
}
-(GLKVector2)center
{
    return GLKVector2Make(_origin.x + _size.x * 0.5, _origin.y + _size.y * 0.5);
}
-(void)setCenter:(GLKVector2)center
{
    self.origin = GLKVector2Make(center.x - _size.x * 0.5, center.y - _size.y * 0.5);
}
-(void)setSize:(GLKVector2)size
{
    _size = size;
    [self updateSourceAttributes];
//    [self updateProjectMatrix];
}
-(void)setOrigin:(GLKVector2)origin size:(GLKVector2)size
{
    _origin = origin;
    _size = size;
    [self updateSourceAttributes];
//    [self updateProjectMatrix];
}
-(void)setCenter:(GLKVector2)center size:(GLKVector2)size
{
    _size = size;
    _origin = GLKVector2Make(center.x - _size.x * 0.5, center.y - _size.y * 0.5);
    [self updateSourceAttributes];
//    [self updateProjectMatrix];
}
- (GLKVector2)size
{
    GLKVector2 transformSize = GLKVector2Make(_size.x * self.matrix.m00, _size.y * self.matrix.m11);
    return transformSize;
}
- (GLKVector2)origin
{
    GLKVector2 size = self.size;
    GLKVector2 transformPosition = GLKVector2Make(self.center.x - size.x * 0.5, self.center.y - size.y * 0.5);
    return transformPosition;
}
- (void)updateSourceAttributes
{
    GLKVector2 displaySize = self.renderer.displaySize;
    GLKVector2 displaySizeRatio =  GLKVector2Make(2/displaySize.x, 2/displaySize.y) ;
    GLfloat *vertexAttr = self.vertexAttributes;

    vertexAttr[0] = vertexAttr[8] = -1 + (_origin.x * displaySizeRatio.x);
    vertexAttr[1] = vertexAttr[5] = 1 - ((_origin.y + _size.y)* displaySizeRatio.y);
    vertexAttr[4] = vertexAttr[12] = -1 + (_origin.x + _size.x) * displaySizeRatio.x;
    vertexAttr[9] = vertexAttr[13] = 1 - (_origin.y * displaySizeRatio.y);
//    vertexAttr[0] = vertexAttr[8] = self.position.x;
//    vertexAttr[1] = vertexAttr[5] = self.position.y + self.size.y;
//    vertexAttr[4] = vertexAttr[12] = self.position.x + self.size.x;
//    vertexAttr[9] = vertexAttr[13] = self.position.y;
    
    [self updateAttributeBuffer];

}
//- (void)updateProjectMatrix
//{
//    GLKVector2 displaySize = self.renderer.displaySize;
//    GLKVector2 displaySizeRatio =  GLKVector2Make(2/displaySize.x, 2/displaySize.y) ;
//
//    self.projectMatrix = GLKMatrix4MakeOrtho(-1 - (_position.x * displaySizeRatio.x), 1 + (displaySize.x - (_position.x + _size.x)) * displaySizeRatio.x,-1 - (displaySize.y - (_position.y + _size.y))* displaySizeRatio.y, 1 + (_position.y * displaySizeRatio.y), 0, 1);
//}
//-(void)updateMatrix
//{
//    self.matrix = GLKMatrix4MakeTranslation(self.size.x * 0.5 + self.position.x, -self.size.y * 0.5 - self.position.y, 0);
//    self.matrix = GLKMatrix4Scale(self.matrix,self.size.x * 0.5, self.size.y * 0.5, 1);
//}

-(void)setTexture:(IPaGLTexture*)texture update:(BOOL)update
{
    //may need to reset image Rect
    self.material.texture = texture;
    GLfloat *vertexAttr = self.vertexAttributes;
    GLKVector2 texCoordRatio = self.material.texture.texCoordRatio;
    
    
    vertexAttr[2] = vertexAttr[10] = 0;
    vertexAttr[3] = vertexAttr[7] = 0;
    vertexAttr[6] = vertexAttr[14] = texCoordRatio.x;
    vertexAttr[11] = vertexAttr[15] = texCoordRatio.y;
        //        [source updateAttributeBuffer];
    
    if (update) {
        [self updateAttributeBuffer];
    }
}
-(void)setTexture:(IPaGLTexture*)texture
{
    [self setTexture:texture update:YES];
}
- (void)render
{
//    renderer.projectionMatrix = self.projectionMatrix;
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
    [self.renderer render:self];
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

@end
