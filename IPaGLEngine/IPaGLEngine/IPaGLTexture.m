//
//  IPaGLTexture.m
//  IPaGLObject
//
//  Created by IPaPa on 13/2/26.
//  Copyright (c) 2013 IPaPa. All rights reserved.
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
    if (name == nil) {
        name = [image description];
    }
    int MAX_TEXTURE_SIZE;
    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &MAX_TEXTURE_SIZE);
    IPaGLTexture *texture = IPaGLTextureList[name];
    if (texture == nil) {
        texture = [[IPaGLTexture alloc] initWithName:name];
        NSDictionary * options = @{ GLKTextureLoaderOriginBottomLeft:@YES};
        NSError *error;
        CGSize imageSize = image.size;
        
        texture.imageSize = GLKVector2Make(imageSize.width, imageSize.height);
        NSInteger temp = 2;
        
        while(temp < imageSize.width)
        {
            temp *= 2;
            if (temp >= MAX_TEXTURE_SIZE) {
                temp = MAX_TEXTURE_SIZE;
                break;
            }
        }
        imageSize.width = temp;
        temp = 2;
        while(temp < imageSize.height)
        {
            temp *= 2;
            if (temp >= MAX_TEXTURE_SIZE) {
                temp = MAX_TEXTURE_SIZE;
                break;
            }
        }
        imageSize.height = temp;
        
        if (!CGSizeEqualToSize(image.size, imageSize)) {
            
            UIGraphicsBeginImageContext(imageSize);
            CGSize newSize = image.size;
            newSize.width = imageSize.width;
            newSize.height = image.size.height / image.size.width * newSize.width;
            
            if (imageSize.height < newSize.height) {
                newSize.height = imageSize.height;
                newSize.width = image.size.width / image.size.height * newSize.height;
            }
            [image drawInRect:CGRectMake(0, imageSize.height - newSize.height,newSize.width,newSize.height)];
            
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            texture.texCoordRatio = GLKVector2Make(newSize.width / imageSize.width, newSize.height / imageSize.height);
            NSLog(@"IPaGLTexture:Image:%@ size is not power of 2",name);
            
            
            
        }
        else {
            texture.texCoordRatio = GLKVector2Make(1,1);
        }
        
        
        texture.textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:options error:&
                               error];
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
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        return [self textureFromImage:image withName:filePath];
        //
        //        texture = [[IPaGLTexture alloc] initWithName:filePath];
        //        NSDictionary * options = @{ GLKTextureLoaderOriginBottomLeft : @(YES)};
        //        NSError *error;
        //        texture.textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:&error];
        //        if (error != nil) {
        //            NSLog(@"IPaGLTexture:textureFromFile error:%@",error);
        //        }
    }
    return texture;
}
-(id)init
{
    self = [super init];
    
    
    
    return self;
}
-(IPaGLTexture*)initWithName:(NSString*)name
{
    IPaGLTexture *texture = IPaGLTextureList[name];
    if (texture != nil) {
        return nil;
    }
    if (self = [super init]) {
        self.materialList = [@[] mutableCopy];
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
    if (self.name != nil && [self.materialList count] == 0) {
        [IPaGLTextureList removeObjectForKey:self.name];
    }
}

@end



