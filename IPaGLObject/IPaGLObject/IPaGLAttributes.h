//
//  IPaGLAttributes.h
//  IPaGLObject
//
//  Created by IPaPa on 13/2/22.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface IPaGLAttributes : NSObject
@property (nonatomic,assign) void *vertexAttributes;
@property (nonatomic,assign) NSUInteger vertexAttributeCount;
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
+(void)releaseSquare2DAttributes;
@end
