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
+(IPaGLTexture*)textureWithName:(NSString*)name
{
    return IPaGLTextureList[name];
}
+(IPaGLTexture*)textureFromImage:(UIImage*)image withName:(NSString*)name
{
    IPaGLTexture *texture = IPaGLTextureList[name];
    if (texture == nil) {
        texture = [[IPaGLTexture alloc] initWithName:name];
        NSDictionary * options = @{ GLKTextureLoaderOriginBottomLeft : @(YES)};
        NSError *error;
        texture.textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:options error:&error];
        if (error != nil) {
            NSLog(@"IPaGLTexture:textureFromImage error:%@",error);
        }
        
    }
    return texture;
}
+(IPaGLTexture*)textureFromFile:(NSString*)filePath
{
    IPaGLTexture *texture = IPaGLTextureList[filePath];
    if (texture == nil) {
        texture = [[IPaGLTexture alloc] initWithName:filePath];
        NSDictionary * options = @{ GLKTextureLoaderOriginBottomLeft : @(YES)};
        NSError *error;
        texture.textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:&error];
        if (error != nil) {
            NSLog(@"IPaGLTexture:textureFromFile error:%@",error);
        }
    }
    return texture;
}
-(id)init
{
    self = [super init];
  
    self.materialList = [@[] mutableCopy];

    return self;
}
-(IPaGLTexture*)initWithName:(NSString*)name
{
    IPaGLTexture *texture = IPaGLTextureList[name];
    if (texture != nil) {
        return nil;
    }
    if (self = [self init]) {
        self.name = name;
        if (IPaGLTextureList == nil) {
            IPaGLTextureList = [@{} mutableCopy];
        }
        IPaGLTextureList[name] = self;
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



