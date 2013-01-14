//
//  IPaWavefrontObject.h
//  IPaWavefrontObject
//
//  Created by IPaPa on 13/1/8.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLKBaseEffect;
@interface IPaWavefrontObject : NSObject
@property (nonatomic, readonly) void *vertexAttributes;
@property (nonatomic, readonly) uint vertexAttributeCount;
@property (nonatomic, readonly) size_t vertexAttributeSize;
@property (nonatomic, readonly) BOOL hasNormals, hasTexCoords;
@property (nonatomic, readonly) NSDictionary *materials;
@property (nonatomic, readonly) NSArray *groups;

//put .obj and .mtl in the same base path
- (id)initWithBasePath:(NSString*)basePath withFileName:(NSString *)fileName;
-(void)createBuffer;
-(void)bindBuffer;
-(void)renderWithGLKBaseEffect:(GLKBaseEffect*)glkEffect;
-(void)bindTexturesWithGLKTextureLoader;
@end
