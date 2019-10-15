//
//  IPaGLPerspectiveSprite2D.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/13.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

@import GLKit;
#import "IPaGLRenderSource.h"
#import "IPaGL2DAction.h"
typedef NS_ENUM(NSUInteger, IPaGLPerspectiveSprite2DCorner) {
    IPaGLPerspectiveSprite2DCornerBottomLeft = 0,
    IPaGLPerspectiveSprite2DCornerBottomRight,
    IPaGLPerspectiveSprite2DCornerUpperLeft ,
    IPaGLPerspectiveSprite2DCornerUpperRight ,
};

@class IPaGLPerspectiveSprite2DRenderer;
@class IPaGLTexture;
@class IPaGLMaterial;
@interface IPaGLPerspectiveSprite2D : IPaGLRenderSource <IPaGL2DActionTarget>
@property (nonatomic,strong) IPaGLPerspectiveSprite2DRenderer* renderer;
@property (nonatomic,assign) CGFloat alpha;
@property (nonatomic,assign) GLKVector2 center;
@property (nonatomic,strong) IPaGLMaterial* material;
@property (nonatomic,assign) GLKMatrix4 matrix;
@property (nonatomic,assign) GLKVector2 position;
-(void)setTexture:(IPaGLTexture*)texture;
-(id)initWithUIImage:(UIImage*)image withName:(NSString*)name renderer:(IPaGLPerspectiveSprite2DRenderer*) useRenderer;
- (void)setCorner:(IPaGLPerspectiveSprite2DCorner)corner position:(GLKVector2)position;
- (GLKVector2)positionForCorner:(IPaGLPerspectiveSprite2DCorner)corner;
- (void)setPosition:(GLKVector2)position size:(GLKVector2)size;
//rect represent (originalX,originalY,width,height)
//-(void)setTextureRect:(GLKVector4)rect;
- (void)render;
- (void)setImage:(UIImage*)image withName:(NSString*)name;
- (void)setImage:(UIImage*)image;
- (GLKVector2)getUVOfPoint:(GLKVector2)point;
- (void)addAction:(IPaGL2DAction*)action;
@end
