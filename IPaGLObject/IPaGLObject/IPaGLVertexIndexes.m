//
//  IPaGLVertexIndexes.m
//  IPaGLObject
//
//  Created by IPaPa on 13/2/26.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLVertexIndexes.h"
@interface IPaGLVertexIndexes()
@property (nonatomic,strong) NSMutableArray *renderGroupList;
@end
@implementation IPaGLVertexIndexes
{
    GLuint indexArrayBuffer;
    GLushort *vertexIndexes;
}
static NSMutableArray *IPaGLVertexIndexesList = nil;
-(IPaGLVertexIndexes*)initWithVertexIndexes:(GLushort*)vIndexes withIndexNumber:(NSUInteger)indexNumber
{
    if (self = [super init]) {
        self.renderGroupList = [@[] mutableCopy];
        _indexNumber = indexNumber;
        vertexIndexes = vIndexes;
        
        [self createBuffer];
        
        if (IPaGLVertexIndexesList == nil) {
            IPaGLVertexIndexesList = [@[] mutableCopy];
        }
        [IPaGLVertexIndexesList addObject:self];
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
-(void)retainByIPaGLRenderGroup:(IPaGLRenderGroup*)group
{
    if ([self.renderGroupList indexOfObject:group] == NSNotFound) {
        [self.renderGroupList addObject:group];
    }

}
-(void)releaseFromIPaGLRenderGroup:(IPaGLRenderGroup*)group
{
    [self.renderGroupList removeObject:group];
    if (self.renderGroupList.count == 0) {
        [IPaGLVertexIndexesList removeObject:self];
    }
}
@end
