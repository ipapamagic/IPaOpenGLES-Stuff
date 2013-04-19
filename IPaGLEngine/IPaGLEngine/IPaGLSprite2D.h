//
//  IPaGLSprite2D.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/7.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class IPaGLRenderer;
@class IPaGLTexture;
@class IPaGLMaterial;
@protocol IPaGLSprite2DRenderer;
@interface IPaGLSprite2D : NSObject
@property (nonatomic,assign) GLKVector2 position;
@property (nonatomic,assign) GLKVector2 size;
@property (nonatomic,strong) IPaGLMaterial* material;
@property (nonatomic,assign) GLKMatrix4 matrix;
//alpha property
-(CGFloat)alpha;
-(void)setAlpha:(CGFloat)alpha;
//center property
-(GLKVector2)center;
-(void)setCenter:(GLKVector2)center;
//
-(void)renderWithRenderer:(IPaGLRenderer <IPaGLSprite2DRenderer> *)renderer;
-(void)setTexture:(IPaGLTexture*)texture;
-(id)initWithUIImage:(UIImage*)image withName:(NSString*)name;
-(void)setPosition:(GLKVector2)position size:(GLKVector2)size;
-(void)setCenter:(GLKVector2)center size:(GLKVector2)size;
//rect represent (originalX,originalY,width,height)
-(void)setTextureRect:(GLKVector4)rect;
@end
