//
//  IPaGLMaterial.h
//  IPaGLObject
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class IPaGLTexture;
@interface IPaGLMaterial : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic,strong) UIColor *constantColor;
@property (nonatomic,strong) UIColor* diffuse;
@property (nonatomic,strong) UIColor* ambient;
@property (nonatomic,strong) UIColor* specular;
@property (nonatomic,assign) GLfloat shininess;
@property (nonatomic,weak) IPaGLTexture *textures;
-(void)bindTexture;
@end
