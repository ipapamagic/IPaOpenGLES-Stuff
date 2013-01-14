//
//  IPaGLRenderGroup.h
//  IPaGLObject
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class IPaGLMaterial;
@class IPaGLRenderer;
@interface IPaGLRenderGroup : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) GLushort *vertexIndexes;
@property (nonatomic, assign) NSUInteger indexNumber;
@property (nonatomic, weak) IPaGLMaterial *material;
- (id)initWithName:(NSString *)inName;
-(void)createBuffer;
-(void)bindBuffer;
@end
