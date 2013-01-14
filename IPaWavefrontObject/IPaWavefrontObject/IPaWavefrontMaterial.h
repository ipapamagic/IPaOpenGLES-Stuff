//
//  IPaWavefrontMaterial.h
//  IPaWavefrontObject
//
//  Created by IPaPa on 13/1/8.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
//@class GLKBaseEffect;
@interface IPaWavefrontMaterial : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic,strong) UIColor* diffuse;
@property (nonatomic,strong) UIColor* ambient;
@property (nonatomic,strong) UIColor* specular;
@property (nonatomic,assign) GLfloat shininess;
@property (nonatomic, copy) NSString *textureFileName;
//for GLKit render

+ (id)defaultMaterial;
+ (id)materialsFromBasePath:(NSString*)basePath MtlFileName:(NSString *)fileName;
- (id)initWithName:(NSString *)inName shininess:(GLfloat)inShininess diffuse:(UIColor*)inDiffuse ambient:(UIColor*)inAmbient specular:(UIColor*)inSpecular;
- (id)initWithName:(NSString *)inName shininess:(GLfloat)inShininess diffuse:(UIColor*)inDiffuse ambient:(UIColor*)inAmbient specular:(UIColor*)inSpecular textureFileName:(NSString *)textureFileName;
-(void)prepareGLKBaseEffect:(GLKBaseEffect*)glkEffect;
-(void)bindTextureWithGLKTextureLoader;
-(void)createTexture;
-(void)bindTexture;
@end
