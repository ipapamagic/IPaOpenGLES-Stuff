//
//  IPaGLMaterial.m
//  IPaGLObject
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLMaterial.h"

@implementation IPaGLMaterial
-(void)setTextureInfo:(GLKTextureInfo *)textureInfo
{
    _textureInfo = textureInfo;
    self.texTarget = textureInfo.target;
    self.textureName = textureInfo.name;
}

-(void)dealloc
{
    glDeleteTextures(1, &_textureName);
}
-(void)bindTexture
{
    if (self.textureName != 0) {
        glBindTexture(self.texTarget, self.textureName);
    }
}
#pragma mark - description
- (NSString *)description
{
    CGFloat diffuseRed,diffuseGreen,diffuseBlue,diffuseAlpha;
    CGFloat ambientRed,ambientGreen,ambientBlue,ambientAlpha;
    CGFloat specularRed,specularGreen,specularBlue,specularAlpha;
    [self.diffuse getRed:&diffuseRed green:&diffuseGreen blue:&diffuseBlue alpha:&diffuseAlpha];
    [self.ambient getRed:&ambientRed green:&ambientGreen blue:&ambientBlue alpha:&ambientAlpha];
    [self.specular getRed:&specularRed green:&specularGreen blue:&specularBlue alpha:&specularAlpha];
    return [NSString stringWithFormat:@"Material: %@ (Shininess: %f, Diffuse: {%f, %f, %f, %f}, Ambient: {%f, %f, %f, %f}, Specular: {%f, %f, %f, %f})", self.name, self.shininess, diffuseRed, diffuseGreen, diffuseBlue, diffuseAlpha, ambientRed, ambientGreen, ambientBlue, ambientAlpha, specularRed, specularGreen, specularBlue, specularAlpha];
}
@end
