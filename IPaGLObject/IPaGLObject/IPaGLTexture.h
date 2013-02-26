//
//  IPaGLTexture.h
//  IPaGLObject
//
//  Created by IPaPa on 13/2/26.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class IPaGLMaterial;
@interface IPaGLTexture : NSObject
//name must be unique
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) GLenum texTarget;
@property (nonatomic,assign) GLuint textureName;
@property (nonatomic,strong) GLKTextureInfo *textureInfo;
//if name already exists ,will return an instance of original texture
-(IPaGLTexture*)initWithName:(NSString*)name;
-(void)bindTexture;
-(void)retainByIPaGLMaterial:(IPaGLMaterial*)material;
-(void)releaseFromIPaGLMaterial:(IPaGLMaterial*)material;
+(IPaGLTexture*)textureFromFile:(NSString*)filePath;
@end