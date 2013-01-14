//
//  IPaGLObject.m
//  IPaGLObject
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLObject.h"
#import "IPaGLRenderGroup.h"
#import <GLKit/GLKit.h>
@interface IPaGLObject()

@end


@implementation IPaGLObject
{

    
    GLuint vertexArray;
    GLuint vertexBuffer;

}
-(void)createBuffer
{
    glGenVertexArraysOES(1, &vertexArray);
    glBindVertexArrayOES(vertexArray);
    
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, self.vertexAttributeSize * self.vertexAttributeCount, self.vertexAttributes, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, self.vertexAttributeSize, 0);
    size_t dataOffset = sizeof(GLfloat) * 3;
    if (_hasTexCoords) {
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, self.vertexAttributeSize, (void*)dataOffset);
        dataOffset += sizeof(GLfloat) * 2;
    }
    if (_hasNormals) {
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, self.vertexAttributeSize, (void*)dataOffset);
        
    }
    glBindVertexArrayOES(0);
    
    
    for (IPaGLRenderGroup* group in self.groups) {
        [group createBuffer];
    }

}
-(void)bindBuffer
{
    if (vertexArray) {
        glBindVertexArrayOES(vertexArray);
    }
}


@end
