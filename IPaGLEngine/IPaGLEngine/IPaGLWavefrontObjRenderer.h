//
//  IPaGLWavefrontObjRenderer.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/18.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "IPaGLShaderRenderer.h"

@interface IPaGLWavefrontObjRenderer : IPaGLShaderRenderer
@property (nonatomic) GLKMatrix4 modelViewProjectionMatrix;
@property (nonatomic) GLKMatrix3 normalMatrix;
@end
