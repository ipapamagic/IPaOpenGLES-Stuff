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
@property (nonatomic,readonly) GLKMatrix4 matrix;
@property (nonatomic,weak) IPaGLRenderer <IPaGLSprite2DRenderer> *renderer;
@property (nonatomic,strong) IPaGLMaterial* material;
-(void)render;
-(void)setTexture:(IPaGLTexture*)texture;
-(id)initWithUIImage:(UIImage*)image withName:(NSString*)name;
-(void)setPosition:(GLKVector2)position size:(GLKVector2)size;
@end
