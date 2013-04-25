//
//  IPaGLGooRenderer.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/25.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLRenderer.h"

@interface IPaGLGooRenderer : IPaGLShaderRenderer
@property (nonatomic,assign) GLKVector4 gooVector;
@property (nonatomic,assign) GLfloat maxMove;
@property (nonatomic,assign) GLfloat range;
@property (nonatomic,assign) GLKMatrix4 matrix;
@end
