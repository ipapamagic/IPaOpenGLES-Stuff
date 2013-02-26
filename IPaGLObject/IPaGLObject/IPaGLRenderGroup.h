//
//  IPaGLRenderGroup.h
//  IPaGLObject
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class IPaGLMaterial;
@class IPaGLRenderer;
@class IPaGLBlender;
@class IPaGLVertexIndexes;
@interface IPaGLRenderGroup : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic,weak) IPaGLVertexIndexes *vertexIndexes;
@property (nonatomic, weak) IPaGLMaterial *material;
@property (nonatomic, strong) IPaGLBlender *blender;
- (id)initWithName:(NSString *)inName;
-(void)bindBuffer;
-(NSUInteger)indexNumber;
-(void)releaseResouces;
@end
