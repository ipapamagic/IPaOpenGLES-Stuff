//
//  IPaGLWavefrontObjRenderGroup.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class IPaGLVertexIndexes;
@class IPaGLMaterial;
@interface IPaGLWavefrontObjRenderGroup : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic,strong) IPaGLVertexIndexes *vertexIndexes;
@property (nonatomic,weak) IPaGLMaterial *material;
@property (nonatomic,assign) GLKVector3 center;
- (id)initWithName:(NSString *)inName;
@end
