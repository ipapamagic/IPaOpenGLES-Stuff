//
//  IPaGLVertexIndexes.h
//  IPaGLObject
//
//  Created by IPaPa on 13/2/26.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class IPaGLRenderGroup;
@interface IPaGLVertexIndexes : NSObject
@property (nonatomic,readonly) NSUInteger indexNumber;
-(IPaGLVertexIndexes*)initWithVertexIndexes:(GLushort*)vIndexes withIndexNumber:(NSUInteger)indexNumber;
-(void)bindBuffer;
@end
