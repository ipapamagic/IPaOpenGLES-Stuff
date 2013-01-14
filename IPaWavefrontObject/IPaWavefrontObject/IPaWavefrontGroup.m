//
//  IPaWavefrontGroup.m
//  IPaWavefrontObject
//
//  Created by IPaPa on 13/1/8.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaWavefrontGroup.h"
#import "IPaWavefrontMaterial.h"

@implementation IPaWavefrontGroup
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
-(void)createBuffer
{

    glGenBuffers(1, &indexArrayBuffer);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexArrayBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, self.indexNumber * sizeof(GLushort), self.vertexIndexes, GL_STATIC_DRAW);
    
    
    
}
-(void)renderWithGLKBaseEffect:(GLKBaseEffect*)glkEffect
{
    [self.material prepareGLKBaseEffect:glkEffect];
    [glkEffect prepareToDraw];
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexArrayBuffer);    
    glDrawElements(GL_TRIANGLES, self.indexNumber, GL_UNSIGNED_SHORT, 0);
    

}
@end
