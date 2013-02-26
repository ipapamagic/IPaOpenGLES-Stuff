//
//  IPaGLTexture.m
//  IPaGLObject
//
//  Created by IPaPa on 13/2/26.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLTexture.h"
@interface IPaGLTexture()
//object that use this attribute
@property (nonatomic,strong) NSMutableArray *materialList;
@end
@implementation IPaGLTexture
static NSMutableDictionary *IPaGLTextureList = nil;

+(IPaGLTexture*)textureFromFile:(NSString*)filePath
{
    if (IPaGLTextureList == nil) {
        IPaGLTextureList = [@{} mutableCopy];
    }
    IPaGLTexture *texture = IPaGLTextureList[filePath];
    if (texture == nil) {
        texture = [[IPaGLTexture alloc] initWithName:filePath];
        NSDictionary * options = @{ GLKTextureLoaderOriginBottomLeft : @(YES)};
        texture.textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
        
    }
    return texture;
}
-(IPaGLTexture*)initWithName:(NSString*)name
{
    IPaGLTexture *texture = IPaGLTextureList[name];
    if (texture != nil) {
        return texture;
    }
    if (self = [super init]) {
        self.name = name;
        if (IPaGLTextureList == nil) {
            IPaGLTextureList = [@{} mutableCopy];
        }
        IPaGLTextureList[name] = self;
        self.materialList = [@[] mutableCopy];
    }
    return self;
}
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
-(void)retainByIPaGLMaterial:(IPaGLMaterial*)material
{
    
    if ([self.materialList indexOfObject:material] == NSNotFound) {
        [self.materialList addObject:material];
    }
}
-(void)releaseFromIPaGLMaterial:(IPaGLMaterial*)material
{
    [self.materialList removeObject:material];
    if ([self.materialList count] == 0) {
        [IPaGLTextureList removeObjectForKey:self.name];
    }
}

@end
