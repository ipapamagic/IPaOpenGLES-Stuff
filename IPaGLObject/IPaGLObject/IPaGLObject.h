//
//  IPaGLObject.h
//  IPaGLObject
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPaGLObject : NSObject
@property (nonatomic) void *vertexAttributes;
@property (nonatomic) uint vertexAttributeCount;
@property (nonatomic) size_t vertexAttributeSize;
@property (nonatomic) BOOL hasNormals, hasTexCoords;
@property (nonatomic) NSDictionary *materials;
@property (nonatomic,strong) NSArray *groups;

-(void)createBuffer;
-(void)bindBuffer;

@end
