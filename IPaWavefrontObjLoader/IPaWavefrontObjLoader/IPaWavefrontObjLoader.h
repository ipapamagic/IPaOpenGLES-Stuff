//
//  IPaWavefrontObjLoader.h
//  IPaWavefrontObjLoader
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IPaGLObject;
@class IPaGLAttributes;
@interface IPaWavefrontObjLoader : NSObject
//you need to record attribute your save
+(IPaGLObject*)loadIPaGLObjectFromObjFile:(NSString*)filePath attributes:(IPaGLAttributes*)attributes;
+(NSDictionary*)loadIPaGLMaterialsFromMTLFile:(NSString*)fileName withBasePath:(NSString*)basePath;
@end
