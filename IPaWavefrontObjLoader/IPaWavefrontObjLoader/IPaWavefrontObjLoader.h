//
//  IPaWavefrontObjLoader.h
//  IPaWavefrontObjLoader
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IPaGLObject;
@interface IPaWavefrontObjLoader : NSObject
+(IPaGLObject*)loadIPaGLObjectFromObjFile:(NSString*)filePath;
+(NSDictionary*)loadIPaGLMaterialsFromMTLFile:(NSString*)fileName withBasePath:(NSString*)basePath;
@end
