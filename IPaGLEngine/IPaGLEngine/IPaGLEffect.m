//
//  IPaGLEffect.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/24.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import "IPaGLEffect.h"

@implementation IPaGLEffect
-(id)initWithSize:(GLKVector2)size meshFactor:(NSUInteger)factor
{
    if (self = [super init]) {
        poolSize = GLKVector2Make(size.x / factor, size.y / factor);
        meshFactor = factor;
        
        source = [[IPaGLRenderSource alloc] init];
        NSUInteger poolWidth = poolSize.x;
        NSUInteger poolHeight = poolSize.y;
        //attribute data initial
        //pos * 2 + uv * 2 = 4
        source.vertexAttributeCount = (poolWidth)*(poolHeight);
        source.vertexAttributes = malloc(source.vertexAttributeCount * 4* sizeof(GLfloat));
        source.attrHasPosZ = NO;
        source.attrHasNormal = NO;
        source.attrHasTexCoords = YES;
        //all vertex will travel once except first and last raw
        //so there will be vertexes of (poolHeight - 1) row that travel twice (first row + last row )
        //every left most and right most vertex will travel one more time
        //so the result will be (poolHeight-1)*(poolWidth*2+2)
        //the first node and last node don't need to travel one more time
        //so  I make it ((poolHeight-1)*(poolWidth*2+2)-2)
        NSUInteger indexNumber = ((poolHeight-1)*(poolWidth*2+2) - 2);
        GLushort * vertexIdx = (GLushort *)malloc(indexNumber*sizeof(GLushort));
        
        
        
        //initial mesh
        GLfloat *vertexAttributes = source.vertexAttributes;
        
        for (int i=0; i<poolHeight; i++)
        {
            for (int j=0; j<poolWidth; j++)
            {
                NSUInteger idx = (i*poolWidth+j)*4;
                vertexAttributes[idx+0] = -1.f + j*(2.f/(poolWidth));
                vertexAttributes[idx+1] = 1.f - i*(2.f/(poolHeight));
                
                vertexAttributes[idx+2] = (GLfloat)j/(poolWidth);
                vertexAttributes[idx+3] = (1.f - (GLfloat)i/(poolHeight));
            }
        }
        
        
        unsigned int index = 0;
        for (int i=0; i<poolHeight-1; i++)
        {
            for (int j=0; j<poolWidth; j++)
            {
                if (i%2 == 0)
                {
                    // emit extra index to create degenerate triangle
                    if (j == 0 && i != 0)
                    {
                        vertexIdx[index] = i*poolWidth+j;
                        index++;
                    }
                    
                    vertexIdx[index] = i*poolWidth+j;
                    index++;
                    vertexIdx[index] = (i+1)*poolWidth+j;
                    index++;
                    
                    // emit extra index to create degenerate triangle
                    if (j == (poolWidth-1) && i != (poolHeight-2))
                    {
                        vertexIdx[index] = (i+1)*poolWidth+j;
                        index++;
                    }
                }
                else
                {
                    // emit extra index to create degenerate triangle
                    if (j == 0)
                    {
                        vertexIdx[index] = (i+1)*poolWidth+j;
                        index++;
                    }
                    
                    vertexIdx[index] = (i+1)*poolWidth+j;
                    index++;
                    vertexIdx[index] = i*poolWidth+j;
                    index++;
                    
                    // emit extra index to create degenerate triangle
                    if (j == (poolWidth-1) && i != (poolHeight-2))
                    {
                        vertexIdx[index] = i*poolWidth+j;
                        index++;
                    }
                }
            }
        }
        vertexIndexes = [[IPaGLVertexIndexes alloc] initWithVertexIndexes:vertexIdx withIndexNumber:indexNumber];
        
        
        
        [source createBufferDynamic];
        material = [[IPaGLMaterial alloc] init];
        
        //texture initial
        
        
        texture = [[IPaGLFramebufferTexture alloc] initWithSize:CGSizeMake(size.x, size.y)];
        

        
        renderer = [[IPaGLKitRenderer alloc] init];
    }
    return self;
}
-(void)dealloc
{
    source = nil;
    texture = nil;
    vertexIndexes = nil;
    [material releaseResource];
    material = nil;
}
-(void)bindFrameBuffer
{
    [texture bindFramebuffer];
    
   
    
}
-(GLKVector2)displaySize
{
    return texture.imageSize;
}

-(void)render
{
    material.texture = texture;
//    material.constantColor = [UIColor blackColor];
//    [source renderWithRenderer:renderer];
    [source bindBuffer];
    [vertexIndexes bindBuffer];
    [renderer prepareToRenderWithMaterial:material];
//    glDrawArrays(GL_POINTS, 0, source.vertexAttributeCount);
    glDrawElements(GL_TRIANGLE_STRIP, (int)vertexIndexes.indexNumber,GL_UNSIGNED_SHORT, 0);
}
-(void)update
{
    
}
-(void)resetMesh
{
    NSUInteger poolWidth = poolSize.x;
    NSUInteger poolHeight = poolSize.y;
    GLfloat *vertexAttributes = source.vertexAttributes;
    
    for (int i=0; i<poolHeight; i++)
    {
        for (int j=0; j<poolWidth; j++)
        {
            NSUInteger idx = (i*poolWidth+j)*4;
            vertexAttributes[idx+0] = -1.f + j*(2.f/(poolWidth));
            vertexAttributes[idx+1] = 1.f - i*(2.f/(poolHeight));
            
            vertexAttributes[idx+2] = (GLfloat)j/(poolWidth);
            vertexAttributes[idx+3] = (1.f - (GLfloat)i/(poolHeight));
        }
    }
    [source updateAttributeBuffer];
}
@end
