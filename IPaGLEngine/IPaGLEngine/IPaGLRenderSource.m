//
//  IPaGLRenderSource.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLRenderSource.h"
#import <GLKit/GLKit.h>
#import "IPaGLRenderer.h"
#import "IPaGLMaterial.h"
typedef enum {
    IPaGLAttr_HasNormal = 1,
    IPaGLAttr_HasTexCoords = 1 << 1,
    IPaGLAttr_HasPosZ = 1 << 2,
}IPaGLAttrFlags;
@implementation IPaGLRenderSource
{
    int atributesFlags;
    GLuint vertexArray;
    GLuint vertexBuffer;
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
    NSInteger posVNum = (self.attrHasPosZ)?3:2;
    return sizeof(GLfloat) * (posVNum + ((self.attrHasNormal)?3:0) + ((self.attrHasTexCoords)?2:0));
    
}

-(void)setAttrHasPosZ:(BOOL)hasPosZ
{
    if (hasPosZ) {
        atributesFlags |= IPaGLAttr_HasPosZ;
    }
    else {
        atributesFlags &= ~IPaGLAttr_HasPosZ;
    }
}
-(void)setAttrHasNormal:(BOOL)hasNormal
{
    if (hasNormal) {
        atributesFlags |= IPaGLAttr_HasNormal;
    }
    else {
        atributesFlags &= ~IPaGLAttr_HasNormal;
    }
}
-(void)setAttrHasTexCoords:(BOOL)hasTexCoords
{
    if (hasTexCoords) {
        atributesFlags |= IPaGLAttr_HasTexCoords;
    }
    else {
        atributesFlags &= ~IPaGLAttr_HasTexCoords;
    }
}
-(BOOL)attrHasPosZ
{
    return (BOOL)(atributesFlags & IPaGLAttr_HasPosZ);
}
-(BOOL)attrHasNormal
{
    return (BOOL)(atributesFlags & IPaGLAttr_HasNormal);
}
-(BOOL)attrHasTexCoords
{
    return (BOOL)(atributesFlags & IPaGLAttr_HasTexCoords);
}
-(void)createBuffer
{
    NSInteger posVNum = (self.attrHasPosZ)?3:2;
    size_t attributesSize = self.vertexAttributeSize;
    glGenVertexArraysOES(1, &vertexArray);
    glBindVertexArrayOES(vertexArray);
    
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, attributesSize * self.vertexAttributeCount, self.vertexAttributes, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, posVNum, GL_FLOAT, GL_FALSE, attributesSize, 0);
    size_t dataOffset = sizeof(GLfloat) * posVNum;
    if (self.attrHasTexCoords) {
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, attributesSize, (void*)dataOffset);
        dataOffset += sizeof(GLfloat) * 2;
    }
    if (self.attrHasNormal) {
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, attributesSize, (void*)dataOffset);
        
    }
    glBindVertexArrayOES(0);
}
-(void)bindBuffer
{
    if (vertexArray != 0) {
        glBindVertexArrayOES(vertexArray);
    }
}
-(void)updateAttributeBuffer
{
    [self bindBuffer];
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, self.vertexAttributeSize * self.vertexAttributeCount, self.vertexAttributes, GL_STATIC_DRAW);
    
}
-(void)renderWithRenderer:(IPaGLRenderer*)renderer;
{
    [renderer prepareToDraw];
    [self bindBuffer];
}

@end
