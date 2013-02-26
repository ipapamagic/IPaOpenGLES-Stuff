//
//  IPaGLObject.h
//  IPaGLObject
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IPaGLAttributes;
@interface IPaGLObject : NSObject
@property (nonatomic,weak) IPaGLAttributes* attributes;
@property (nonatomic) NSDictionary *materials;
@property (nonatomic,strong) NSArray *groups;


+(IPaGLObject*)objectFromWavefrontObjFile:(NSString*)filePath;

-(void)bindAttributeBuffer;

//you need to releaseResources if you want to delete IPaGLObject
//or it may cause memory leak
-(void)releaseResources;
@end
