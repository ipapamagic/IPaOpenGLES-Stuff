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
@property (nonatomic,readwrite) GLKVector2 imageSize;
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
        CGSize imageSize = image.size;
        
        texture.imageSize = GLKVector2Make(imageSize.width, imageSize.height);
        NSInteger temp = 2;
        
        while(temp < imageSize.width)
        {
            temp *= 2;
            if (temp >= MAX_TEXTURE_WIDTH) {
                temp = MAX_TEXTURE_WIDTH;
                break;
            }
        }
        imageSize.width = temp;
        temp = 2;
        while(temp < imageSize.height)
        {
            temp *= 2;
            if (temp >= MAX_TEXTURE_HEIGHT) {
                temp = MAX_TEXTURE_HEIGHT;
                break;
            }
        }
        imageSize.height = temp;
        
        if (!CGSizeEqualToSize(image.size, imageSize)) {
//            texture.texCoordRatio = GLKVector2Make(image.size.width / imageSize.width, image.size.height / imageSize.height);
            UIGraphicsBeginImageContext(imageSize);
//            [image drawAtPoint:CGPointMake(0, imageSize.height - image.size.height)];
            [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            
           
            

        }
//        else {
//            texture.texCoordRatio = GLKVector2Make(1,1);
//        }
        
        
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
    if (self.name != nil && [self.materialList count] == 0) {
        [IPaGLTextureList removeObjectForKey:self.name];
    }
}

@end



