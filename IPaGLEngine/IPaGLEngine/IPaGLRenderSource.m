//
//  IPaGLRenderSource.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "IPaGLRenderSource.h"
#import <OpenGLES/ES2/glext.h>
#import "IPaGLMaterial.h"
typedef enum {
    IPaGLAttr_HasNormal = 1,
    IPaGLAttr_HasTexCoords = 1 << 1,
    IPaGLAttr_HasTexCoords3D = 1 << 2,
    IPaGLAttr_HasPosZ = 1 << 3,
}IPaGLAttrFlags;
@implementation IPaGLRenderSource
{
    int atributesFlags;
    GLuint vertexArray;
    GLuint vertexBuffer;
}

-(void)dealloc
{
    [self removeBuffer];
    if (self.vertexAttributes != nil) {
        free(self.vertexAttributes);
    }
}
- (void)removeBuffer
{
    if (vertexBuffer != 0) {
        glDeleteBuffers(1, &vertexBuffer);
    }
    if (vertexArray != 0) {
        glDeleteVertexArraysOES(1, &vertexArray);
    }

    
}
-(size_t)vertexAttributeSize
{
    GLint posVNum = (self.attrHasPosZ)?3:2;
    GLint texNum = ((self.attrHasTexCoords)?((self.attrHasTexCoords3D)?3:2):0);
    return sizeof(GLfloat) * (posVNum + ((self.attrHasNormal)?3:0) + texNum);
    
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
- (void)setAttrHasTexCoords3D:(BOOL)hasTexCoords3D
{
    if (hasTexCoords3D) {
        atributesFlags |= (IPaGLAttr_HasTexCoords | IPaGLAttr_HasTexCoords3D);
    }
    else {
        atributesFlags &= ~IPaGLAttr_HasTexCoords3D;
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
-(BOOL)attrHasTexCoords3D
{
    return (BOOL)(atributesFlags & IPaGLAttr_HasTexCoords3D);
}

//create buffer with GL_STATIC_DRAW
-(void)createBufferStatic
{
    [self createBuffer:GL_STATIC_DRAW];
}
//create buffer with GL_DYNAMIC_DRAW
-(void)createBufferDynamic
{
    [self createBuffer:GL_DYNAMIC_DRAW];
}
-(void)createBuffer:(GLenum)bufferUsage
{

    size_t attributesSize = self.vertexAttributeSize;
    glGenVertexArraysOES(1, &vertexArray);
    glBindVertexArrayOES(vertexArray);
    
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, attributesSize * self.vertexAttributeCount, self.vertexAttributes, bufferUsage);
    NSInteger posVNum = (self.attrHasPosZ)?3:2;
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, (int)posVNum, GL_FLOAT, GL_FALSE, (int)attributesSize, 0);
    size_t dataOffset = sizeof(GLfloat) * posVNum;
    if (self.attrHasTexCoords) {
        GLint count = (self.attrHasTexCoords3D)?3:2;
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, count, GL_FLOAT, GL_FALSE, (int)attributesSize, (void*)dataOffset);
        dataOffset += sizeof(GLfloat) * count;
    }
    if (self.attrHasNormal) {
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, (int)attributesSize, (void*)dataOffset);
    }
    [self bindAttribute:attributesSize dataOffset:dataOffset];
    glBindVertexArrayOES(0);
}

//for subclass to override
-(void)bindAttribute:(size_t)attributeSize dataOffset:(size_t)dataOffset
{
    
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
    glBufferSubData(GL_ARRAY_BUFFER, 0, self.vertexAttributeSize * self.vertexAttributeCount, self.vertexAttributes);
    
    
//    glBufferData(GL_ARRAY_BUFFER, self.vertexAttributeSize * self.vertexAttributeCount, self.vertexAttributes, GL_STATIC_DRAW);
    glBindVertexArrayOES(0);    
}
//-(void)renderWithRenderer:(id <IPaGLRenderer>)renderer;
//{
//    [renderer prepareToDraw];
//    [self bindBuffer];
//}

@end
