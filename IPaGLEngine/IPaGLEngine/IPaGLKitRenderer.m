//
//  IPaGLKitRenderer.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/9.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLKitRenderer.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
@implementation IPaGLKitRenderer
-(id)init
{
    if (self = [super init])
    {
        self.effect = [[GLKBaseEffect alloc] init];
    }
    
    return self;
}
-(void)prepareToDraw
{
    
    
}
-(void)prepareToRenderWithMaterial:(IPaGLMaterial*)material
{
    if (material == nil) {
        self.effect.constantColor = GLKVector4Make(1,1,1,1);
        self.effect.light0.diffuseColor = GLKVector4Make(0,0,0,0);
        self.effect.light0.specularColor = GLKVector4Make(0,0,0,0);
        self.effect.light0.ambientColor = GLKVector4Make(0,0,0,0);
        self.effect.light0.linearAttenuation = 0;
        self.effect.texture2d0.enabled = GL_FALSE;
    }
    else {
        UIColor *color = material.constantColor;
        CGFloat r,g,b,a;
        if (color == nil) {
            r = g = b = a = 1;
        }
        else {
            [color getRed:&r green:&g blue:&b alpha:&a];
        }
        self.effect.constantColor = GLKVector4Make(r,g,b,a);
        
        color = material.diffuse;
        if (color == nil) {
            r = g = b = a = 0;
        }
        else {
            [color getRed:&r green:&g blue:&b alpha:&a];
        }
        self.effect.light0.diffuseColor = GLKVector4Make(r,g,b,a);
        color = material.specular;
        if (color == nil) {
            r = g = b = a = 0;
        }
        else {
            [color getRed:&r green:&g blue:&b alpha:&a];
        }
        self.effect.light0.specularColor = GLKVector4Make(r,g,b,a);
        color = material.ambient;
        if (color == nil) {
            r = g = b = a = 0;
        }
        else {
            [color getRed:&r green:&g blue:&b alpha:&a];
        }
        self.effect.light0.ambientColor = GLKVector4Make(r,g,b,a);
        self.effect.light0.linearAttenuation = material.shininess;
        if (material.texture != nil) {
            self.effect.texture2d0.name = material.texture.textureName;
            //        self.effect.constantColor = GLKVector4Make(0.0, 0.0, 0.0, 1);
            self.effect.texture2d0.enabled = GL_TRUE;
            //        self.effect.texture2d0.envMode = GLKTextureEnvModeDecal;
        }
        else {
            self.effect.texture2d0.enabled = GL_FALSE;
        }
    }
    [self.effect prepareToDraw];
}
-(void)setProjectionMatrix:(GLKMatrix4)projectionMatrix
{
    self.effect.transform.projectionMatrix = projectionMatrix;
}
-(GLKMatrix4)projectionMatrix
{
    return self.effect.transform.projectionMatrix;
}
-(void)setModelMatrix:(GLKMatrix4)modelMatrix
{
    self.effect.transform.modelviewMatrix = modelMatrix;
}
-(GLKMatrix4)modelMatrix
{
    return self.effect.transform.modelviewMatrix;
}
@end