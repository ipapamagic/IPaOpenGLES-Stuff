//
//  IPaGLToonRenderer.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/6/4.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "IPaGLRenderer.h"

@interface IPaGLToonRenderer : IPaGLShaderRenderer
@property (nonatomic) GLKMatrix4 modelViewProjectionMatrix;
@property (nonatomic) GLKVector3 lightPosition;
@property (nonatomic) GLKVector3 eyePosition;
@property (nonatomic) GLfloat shininess;
@end
