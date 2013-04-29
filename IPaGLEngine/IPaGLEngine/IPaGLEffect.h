//
//  IPaGLEffect.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/24.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLRenderSource.h"
#import "IPaGLRenderSource.h"
#import "IPaGLMaterial.h"
#import "IPaGLFramebufferTexture.h"
#import "IPaGLVertexIndexes.h"
#import "IPaGLRenderer.h"
@interface IPaGLEffect : IPaGLRenderSource
{
    IPaGLRenderSource *source;
    NSUInteger meshFactor;
    IPaGLMaterial *material;
    GLKVector2 poolSize;
    IPaGLFramebufferTexture *texture;
    IPaGLVertexIndexes *vertexIndexes;
    IPaGLKitRenderer *renderer;
}
-(id)initWithSize:(GLKVector2)size meshFactor:(NSUInteger)factor;
-(void)update;
-(void)render;
//call it before you want to draw something to texture of this effect
-(void)bindFrameBuffer;
-(GLKVector2)displaySize;
-(void)resetMesh;
@end
