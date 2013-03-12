//
//  IPaGLRenderSource.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IPaGLRenderer;
@interface IPaGLRenderSource : NSObject
@property (nonatomic,assign) void *vertexAttributes;
@property (nonatomic,assign) NSUInteger vertexAttributeCount;


-(void)createBuffer;
-(void)bindBuffer;
-(void)updateAttributeBuffer;
-(size_t)vertexAttributeSize;
-(BOOL)attrHasPosZ;
-(BOOL)attrHasNormal;
-(BOOL)attrHasTexCoords;
-(void)setAttrHasPosZ:(BOOL)hasPosZ;
-(void)setAttrHasNormal:(BOOL)hasNormal;
-(void)setAttrHasTexCoords:(BOOL)hasTexCoords;

-(void)renderWithRenderer:(IPaGLRenderer*)renderer;

@end
