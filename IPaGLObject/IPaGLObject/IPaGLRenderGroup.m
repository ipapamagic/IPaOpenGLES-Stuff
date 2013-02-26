//
//  IPaGLRenderGroup.m
//  IPaGLObject
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLRenderGroup.h"
#import "IPaGLVertexIndexes.h"
@interface IPaGLRenderGroup ()
@end
@implementation IPaGLRenderGroup
{

}
- (id)initWithName:(NSString *)inName
{
	if ((self = [super init]))
	{
		self.name = inName;
	}
	return self;
}
-(void)bindBuffer
{
    [self.vertexIndexes bindBuffer];
}

-(NSUInteger)indexNumber
{
    return self.vertexIndexes.indexNumber;
}
-(void)setVertexIndexes:(IPaGLVertexIndexes *)vertexIndexes
{
    [_vertexIndexes releaseFromIPaGLRenderGroup:self];
    _vertexIndexes = vertexIndexes;
    [vertexIndexes retainByIPaGLRenderGroup:self];
}
-(void)releaseResouces
{
    self.vertexIndexes = nil;
}
@end
