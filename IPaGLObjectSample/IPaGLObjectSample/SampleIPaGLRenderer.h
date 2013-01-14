//
//  SampleIPaGLRender.h
//  IPaGLObjectSample
//
//  Created by IPaPa on 13/1/13.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLRenderer.h"

@interface SampleIPaGLRenderer : IPaGLShaderRenderer
@property (nonatomic) GLKMatrix4 modelViewProjectionMatrix;
@property (nonatomic) GLKMatrix3 normalMatrix;
@property (nonatomic) float rotation;
@end
