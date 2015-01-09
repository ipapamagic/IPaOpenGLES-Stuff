//
//  IPaGLVertexIndexes.m
//  IPaGLObject
//
//  Created by IPaPa on 13/2/26.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "IPaGLVertexIndexes.h"
@interface IPaGLVertexIndexes()
@end
@implementation IPaGLVertexIndexes
{
    GLuint indexArrayBuffer;
    GLushort *vertexIndexes;
}
-(IPaGLVertexIndexes*)initWithVertexIndexes:(GLushort*)vIndexes withIndexNumber:(NSUInteger)indexNumber
{
    if (self = [super init]) {

        _indexNumber = indexNumber;
        vertexIndexes = vIndexes;
        
        [self createBuffer];
        
    }
    return self;
}

-(void)dealloc
{
    if (vertexIndexes) {
        free(vertexIndexes);
    }
    if (indexArrayBuffer != 0) {
        glDeleteBuffers(1, &indexArrayBuffer);
    }
}
-(void)bindBuffer
{
    if (indexArrayBuffer != 0) {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexArrayBuffer);
    }
}
-(void)createBuffer
{
    if (indexArrayBuffer != 0) {
        glDeleteBuffers(1, &indexArrayBuffer);
    }
    glGenBuffers(1, &indexArrayBuffer);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexArrayBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, self.indexNumber * sizeof(GLushort), vertexIndexes, GL_STATIC_DRAW);
    
}

@end
