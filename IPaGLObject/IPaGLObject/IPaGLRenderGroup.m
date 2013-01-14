//
//  IPaGLRenderGroup.m
//  IPaGLObject
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLRenderGroup.h"
#import "IPaGLRenderer.h"
#import "IPaGLMaterial.h"
@implementation IPaGLRenderGroup
{
    GLuint indexArrayBuffer;
}
- (id)initWithName:(NSString *)inName
{
	if ((self = [super init]))
	{
		self.name = inName;
	}
	return self;
}
-(void)setIndexNumber:(NSUInteger)indexNumber
{
    _indexNumber = indexNumber;
    if (self.vertexIndexes) {
        free(self.vertexIndexes);
    }
    self.vertexIndexes = malloc(sizeof(GLushort) * indexNumber);
    
}
-(void)dealloc
{
    if (self.vertexIndexes) {
        free(self.vertexIndexes);
    }
    if (indexArrayBuffer) {
        glDeleteBuffers(1, &indexArrayBuffer);
    }
}
-(void)bindBuffer
{
    if (indexArrayBuffer) {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexArrayBuffer);
    }
}
-(void)createBuffer
{
    
    glGenBuffers(1, &indexArrayBuffer);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexArrayBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, self.indexNumber * sizeof(GLushort), self.vertexIndexes, GL_STATIC_DRAW);
    
    
    
}



@end
