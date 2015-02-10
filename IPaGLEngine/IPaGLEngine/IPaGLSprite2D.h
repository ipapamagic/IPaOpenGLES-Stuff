//
//  IPaGLSprite2D.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/7.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPaGLRenderSource.h"
@import GLKit;
@class IPaGLTexture;
@class IPaGLMaterial;
@class IPaGLSprite2DRenderer;

@interface IPaGLSprite2D : IPaGLRenderSource
@property (nonatomic,assign) GLKVector2 position;
@property (nonatomic,assign) GLKVector2 size;
@property (nonatomic,strong) IPaGLMaterial* material;
@property (nonatomic,assign) GLKMatrix4 matrix;
@property (nonatomic,assign) GLKMatrix4 projectMatrix;
@property (nonatomic,strong) IPaGLSprite2DRenderer* renderer;
@property (nonatomic,assign) CGFloat alpha;
@property (nonatomic,assign) GLKVector2 center;
//
-(void)setTexture:(IPaGLTexture*)texture;
- (instancetype)initWithTexture:(IPaGLTexture*)texture renderer:(IPaGLSprite2DRenderer*) useRenderer;
-(id)initWithUIImage:(UIImage*)image withName:(NSString*)name renderer:(IPaGLSprite2DRenderer*) useRenderer;
-(void)setPosition:(GLKVector2)position size:(GLKVector2)size;
-(void)setCenter:(GLKVector2)center size:(GLKVector2)size;
//rect represent (originalX,originalY,width,height)
-(void)setTextureRect:(GLKVector4)rect;
- (void)render;
- (void)setImage:(UIImage*)image withName:(NSString*)name;
- (void)setImage:(UIImage*)image;

@end
