//
//  IPaGLRenderSource.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPaGLRenderSource : NSObject
@property (nonatomic,assign) void *vertexAttributes;
@property (nonatomic,assign) NSUInteger vertexAttributeCount;


//create buffer with GL_STATIC_DRAW
-(void)createBufferStatic;
//create buffer with GL_DYNAMIC_DRAW
-(void)createBufferDynamic;
- (void)removeBuffer;
-(void)bindBuffer;
-(void)updateAttributeBuffer;
-(size_t)vertexAttributeSize;
-(BOOL)attrHasPosZ;
-(BOOL)attrHasNormal;
-(BOOL)attrHasTexCoords;
-(BOOL)attrHasTexCoords3D;
-(void)setAttrHasPosZ:(BOOL)hasPosZ;
-(void)setAttrHasNormal:(BOOL)hasNormal;
-(void)setAttrHasTexCoords:(BOOL)hasTexCoords;
- (void)setAttrHasTexCoords3D:(BOOL)hasTexCoords3D;


@end
