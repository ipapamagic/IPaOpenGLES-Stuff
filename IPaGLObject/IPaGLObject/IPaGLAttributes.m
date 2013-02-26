//
//  IPaGLAttributes.m
//  IPaGLObject
//
//  Created by IPaPa on 13/2/22.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLAttributes.h"
#import <GLKit/GLKit.h>
#import "IPaGLObject.h"
typedef enum {
    IPaGLAttr_HasNormal = 1,
    IPaGLAttr_HasTexCoords = 1 << 1,
    IPaGLAttr_HasPosZ = 1 << 2,
}IPaGLAttrFlags;
@interface IPaGLAttributes()
//object that use this attribute
@property (nonatomic,strong) NSMutableArray *objectList;
@end


@implementation IPaGLAttributes
{
    int atributesFlags;
    GLuint vertexArray;
    GLuint vertexBuffer;
}
static IPaGLAttributes *square2DAttributes = nil;
static NSMutableArray *IPaGLAttributeList = nil;
-(id)init;
{
    if(self = [super init])
    {
        if (IPaGLAttributeList == nil) {
            IPaGLAttributeList = [@[] mutableCopy];
            [IPaGLAttributeList addObject:self];
        }
    
        self.objectList = [@[] mutableCopy];
    }
    return self;
}
-(void)retainByIPaGLObject:(IPaGLObject*)object
{
    if ([self.objectList indexOfObject:object] == NSNotFound) {
        [self.objectList addObject:object];
    }
}
-(void)releaseFromIPaGLObject:(IPaGLObject*)object
{
    [self.objectList removeObject:object];
    if ([self.objectList count] == 0) {
        [IPaGLAttributeList removeObject:self];
    }
}
-(void)dealloc
{
    if (vertexBuffer != 0) {
        glDeleteBuffers(1, &vertexBuffer);
    }
    if (vertexArray != 0) {
        glDeleteVertexArraysOES(1, &vertexArray);
    }
    if (self.vertexAttributes != nil) {
        free(self.vertexAttributes);
    }
}
-(size_t)vertexAttributeSize
{
    NSInteger posVNum = (self.hasPosZ)?3:2;
    return sizeof(GLfloat) * (posVNum + ((self.hasNormal)?3:0) + ((self.hasTexCoords)?2:0));
    
}
-(void)setVertexAttributes:(void *)vertexAttributes
{
    if (_vertexAttributes != nil) {
        free(_vertexAttributes);
    }
    _vertexAttributes = vertexAttributes;
}
-(void)setHasPosZ:(BOOL)hasPosZ
{
    if (hasPosZ) {
        atributesFlags |= IPaGLAttr_HasPosZ;
    }
    else {
        atributesFlags &= ~IPaGLAttr_HasPosZ;
    }
}
-(void)setHasNormal:(BOOL)hasNormal
{
    if (hasNormal) {
        atributesFlags |= IPaGLAttr_HasNormal;
    }
    else {
        atributesFlags &= ~IPaGLAttr_HasNormal;
    }
}
-(void)setHasTexCoords:(BOOL)hasTexCoords
{
    if (hasTexCoords) {
        atributesFlags |= IPaGLAttr_HasTexCoords;
    }
    else {
        atributesFlags &= ~IPaGLAttr_HasTexCoords;
    }
}
-(BOOL)hasPosZ
{
    return (BOOL)(atributesFlags & IPaGLAttr_HasPosZ);
}
-(BOOL)hasNormal
{
    return (BOOL)(atributesFlags & IPaGLAttr_HasNormal);
}
-(BOOL)hasTexCoords
{
    return (BOOL)(atributesFlags & IPaGLAttr_HasTexCoords);
}
-(void)createBuffer
{
    NSInteger posVNum = (self.hasPosZ)?3:2;
    size_t attributesSize = self.vertexAttributeSize;
    glGenVertexArraysOES(1, &vertexArray);
    glBindVertexArrayOES(vertexArray);
    
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, attributesSize * self.vertexAttributeCount, self.vertexAttributes, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, posVNum, GL_FLOAT, GL_FALSE, attributesSize, 0);
    size_t dataOffset = sizeof(GLfloat) * posVNum;
    if (self.hasTexCoords) {
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, attributesSize, (void*)dataOffset);
        dataOffset += sizeof(GLfloat) * 2;
    }
    if (self.hasNormal) {
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, attributesSize, (void*)dataOffset);
        
    }
    glBindVertexArrayOES(0);
}
-(void)bindBuffer
{
    if (vertexArray) {
        glBindVertexArrayOES(vertexArray);
    }
}
-(void)updateAttributeBuffer
{
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, self.vertexAttributeSize * self.vertexAttributeCount, self.vertexAttributes, GL_STATIC_DRAW);
    
}
#pragma mark - Global
+(IPaGLAttributes*)square2DAttributes
{
    
    if (square2DAttributes == nil) {
        square2DAttributes = [[IPaGLAttributes alloc] init];
        GLfloat VertexData[] = {
            //底
            -1,-1,0,0,
            1,-1,1,0,
            -1,1,0,1,
            1,1,1,1,
        };
        square2DAttributes.vertexAttributes = malloc(sizeof(VertexData));
        memcpy(square2DAttributes.vertexAttributes, VertexData, sizeof(VertexData));
        square2DAttributes.vertexAttributeCount = 4;
        square2DAttributes.hasPosZ = NO;
        square2DAttributes.hasNormal = NO;
        square2DAttributes.hasTexCoords = YES;
        [square2DAttributes createBuffer];
    }
    
    return square2DAttributes;
}

@end
