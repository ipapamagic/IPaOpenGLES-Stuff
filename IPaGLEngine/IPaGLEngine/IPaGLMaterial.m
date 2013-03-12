//
//  IPaGLMaterial.m
//  IPaGLObject
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
@interface IPaGLMaterial () <NSCopying>
@end
@implementation IPaGLMaterial
-(void)dealloc
{
    
}
-(void)releaseResource
{
    self.texture = nil;
}
-(void)setTexture:(IPaGLTexture *)texture
{
    [_texture releaseFromIPaGLMaterial:self];
    _texture = texture;
    [texture retainByIPaGLMaterial:self];
}
-(void)bindTexture
{
    [self.texture bindTexture];
}
#pragma mark - description
- (NSString *)description
{
    CGFloat constRed,constGreen,constBlue,constAlpha;
    CGFloat diffuseRed,diffuseGreen,diffuseBlue,diffuseAlpha;
    CGFloat ambientRed,ambientGreen,ambientBlue,ambientAlpha;
    CGFloat specularRed,specularGreen,specularBlue,specularAlpha;
    [self.constantColor getRed:&constRed green:&constGreen blue:&constBlue alpha:&constAlpha];
    [self.diffuse getRed:&diffuseRed green:&diffuseGreen blue:&diffuseBlue alpha:&diffuseAlpha];
    [self.ambient getRed:&ambientRed green:&ambientGreen blue:&ambientBlue alpha:&ambientAlpha];
    [self.specular getRed:&specularRed green:&specularGreen blue:&specularBlue alpha:&specularAlpha];
    return [NSString stringWithFormat:@"Material: %@ (Shininess: %f, ConstantColor:{%f, %f, %f, %f} Diffuse: {%f, %f, %f, %f}, Ambient: {%f, %f, %f, %f}, Specular: {%f, %f, %f, %f})", self.name, self.shininess, constRed,constGreen,constBlue,constAlpha ,diffuseRed, diffuseGreen, diffuseBlue, diffuseAlpha, ambientRed, ambientGreen, ambientBlue, ambientAlpha, specularRed, specularGreen, specularBlue, specularAlpha];
}
#pragma mark - NSCopying Protocol
-(id)copyWithZone:(NSZone *)zone
{
    IPaGLMaterial *newMaterial = [super copy];
    newMaterial.name = self.name;
    newMaterial.constantColor = [self.constantColor copy];
    newMaterial.diffuse = [self.diffuse copy];
    newMaterial.ambient = [self.ambient copy];
    newMaterial.specular = [self.specular copy];
    newMaterial.shininess = self.shininess;
    newMaterial.texture = self.texture;
    return newMaterial;
}
@end
