//
//  IPaGLRenderer.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/1/13.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
//@class IPaGLRenderGroup;
@class IPaGLMaterial;
@class IPaGLRenderSource;
@protocol IPaGLRenderer <NSObject>
-(void)prepareToDraw;
-(void)prepareToRenderWithMaterial:(IPaGLMaterial*)material;
- (void)setProjectionMatrix:(GLKMatrix4)projectionMatrix;
@end



