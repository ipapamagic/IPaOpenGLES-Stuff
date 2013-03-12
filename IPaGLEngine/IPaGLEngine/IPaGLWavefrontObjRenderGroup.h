//
//  IPaGLWavefrontObjRenderGroup.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IPaGLVertexIndexes;
@class IPaGLMaterial;
@interface IPaGLWavefrontObjRenderGroup : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic,strong) IPaGLVertexIndexes *vertexIndexes;
@property (nonatomic,weak) IPaGLMaterial *material;
- (id)initWithName:(NSString *)inName;
@end
