//
//  IPaGLAttributes.h
//  IPaGLObject
//
//  Created by IPaPa on 13/2/22.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class IPaGLObject;
@interface IPaGLAttributes : NSObject
@property (nonatomic,assign) void *vertexAttributes;
@property (nonatomic,assign) NSUInteger vertexAttributeCount;

//make sure to retain and release IPaGLObject correctly that uses this Attributes
-(void)retainByIPaGLObject:(IPaGLObject*)object;
-(void)releaseFromIPaGLObject:(IPaGLObject*)object;

-(void)createBuffer;
-(void)bindBuffer;
-(void)updateAttributeBuffer;
-(size_t)vertexAttributeSize;
-(BOOL)hasPosZ;
-(BOOL)hasNormal;
-(BOOL)hasTexCoords;
-(void)setHasPosZ:(BOOL)hasPosZ;
-(void)setHasNormal:(BOOL)hasNormal;
-(void)setHasTexCoords:(BOOL)hasTexCoords;


//a square data,you can use it to draw a 2D square
+(IPaGLAttributes*)square2DAttributes;
@end
