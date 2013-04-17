//
//  IPaGLTexture.h
//  IPaGLObject
//
//  Created by IPaPa on 13/2/26.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#define MAX_TEXTURE_WIDTH 2048
#define MAX_TEXTURE_HEIGHT 2048
@class IPaGLMaterial;
@interface IPaGLTexture : NSObject
//name must be unique
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) GLenum texTarget;
@property (nonatomic,assign) GLuint textureName;
//ratio of original image size and texture size
//@property (nonatomic,assign) GLKVector2 texCoordRatio;
//original image size
@property (nonatomic,readonly) GLKVector2 imageSize;
@property (nonatomic,strong) GLKTextureInfo *textureInfo;
//if name already exists ,will return an instance of original texture
-(IPaGLTexture*)initWithName:(NSString*)name;
-(void)bindTexture;
-(void)retainByIPaGLMaterial:(IPaGLMaterial*)material;
-(void)releaseFromIPaGLMaterial:(IPaGLMaterial*)material;
+(IPaGLTexture*)textureFromFile:(NSString*)filePath;
+(IPaGLTexture*)textureFromImage:(UIImage*)image withName:(NSString*)name;
+(IPaGLTexture*)textureWithName:(NSString*)name;
@end
