//
//  IPaGLWaterRippleEffect.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/23.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLWaterRippleEffect.h"

//#import "IPaGLWaterRippleRenderer.h"
@implementation IPaGLWaterRippleEffect
{
    // ripple coefficients
    GLfloat *rippleCoeff;
    // ripple simulation buffers
    GLfloat *rippleSource;
    GLfloat *rippleDest;
    NSUInteger radius;
}
-(id)initWithSize:(GLKVector2)size meshFactor:(NSUInteger)factor rippleRadius:(NSUInteger)rippleRadius
{
    if (self = [super initWithSize:size meshFactor:factor]) {
        radius = rippleRadius;
        NSUInteger poolWidth = poolSize.x;
        NSUInteger poolHeight = poolSize.y;
        
        //ripple data
        // +2 for padding the border
        rippleSource = (GLfloat *)malloc((poolWidth+2)*(poolHeight+2)*sizeof(GLfloat));
        rippleDest = (GLfloat *)malloc((poolWidth+2)*(poolHeight+2)*sizeof(GLfloat));
        //initial ripple map
        memset(rippleSource, 0, (poolWidth+2)*(poolHeight+2)*sizeof(float));
        memset(rippleDest, 0, (poolWidth+2)*(poolHeight+2)*sizeof(float));
        
        //initial ripple coeff
        rippleCoeff = (GLfloat *)malloc((rippleRadius*2+1)*(rippleRadius*2+1)*sizeof(GLfloat));
        for (int y=0; y<=2*rippleRadius; y++)
        {
            for (int x=0; x<=2*rippleRadius; x++)
            {
                float distance = sqrt((x-rippleRadius)*(x-rippleRadius)+(y-rippleRadius)*(y-rippleRadius));
                
                if (distance <= rippleRadius)
                {
                    float factor = (distance/rippleRadius);
                    
                    // goes from -512 -> 0
                    rippleCoeff[y*(rippleRadius*2+1)+x] = -(cos(factor*M_PI)+1.f) * 256.f;
                }
                else
                {
                    rippleCoeff[y*(rippleRadius*2+1)+x] = 0.f;
                }
            }
        }
        
     
    }
    return self;
}
-(void)dealloc
{
    free(rippleCoeff);
    
    free(rippleSource);
    free(rippleDest);
    
}

-(void)update
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSUInteger poolWidth = poolSize.x;
    NSUInteger poolHeight = poolSize.y;
    // first pass for simulation buffers...
    dispatch_apply(poolHeight, queue, ^(size_t y) {
        for (int x=0; x<poolWidth; x++)
        {
            // * - denotes current pixel
            //
            //       a
            //     c * d
            //       b
            
            // +1 to both x/y values because the border is padded
            float a = rippleSource[(y)*(poolWidth+2) + x+1];
            float b = rippleSource[(y+2)*(poolWidth+2) + x+1];
            float c = rippleSource[(y+1)*(poolWidth+2) + x];
            float d = rippleSource[(y+1)*(poolWidth+2) + x+2];
            
            float result = (a + b + c + d)/2.f - rippleDest[(y+1)*(poolWidth+2) + x+1];
            
            result -= result/32.f;
            
            rippleDest[(y+1)*(poolWidth+2) + x+1] = result;
        }
    });
    
    // second pass for modifying texture coord
    dispatch_apply(poolHeight, queue, ^(size_t y) {
        for (int x=0; x<poolWidth; x++)
        {
            // * - denotes current pixel
            //
            //       a
            //     c * d
            //       b
            
            // +1 to both x/y values because the border is padded
            float a = rippleDest[(y)*(poolWidth+2) + x+1];
            float b = rippleDest[(y+2)*(poolWidth+2) + x+1];
            float c = rippleDest[(y+1)*(poolWidth+2) + x];
            float d = rippleDest[(y+1)*(poolWidth+2) + x+2];
            
            float s_offset = ((b - a) / 2048.f);
            float t_offset = ((c - d) / 2048.f);
            
            // clamp
            s_offset = (s_offset < -0.5f) ? -0.5f : s_offset;
            t_offset = (t_offset < -0.5f) ? -0.5f : t_offset;
            s_offset = (s_offset > 0.5f) ? 0.5f : s_offset;
            t_offset = (t_offset > 0.5f) ? 0.5f : t_offset;
            
            float s_tc = (float)x/(poolWidth-1);
            float t_tc = (1.f - (float)y/(poolHeight-1));
            GLfloat *rippleVertexes = source.vertexAttributes;
            rippleVertexes[(y*poolWidth+x)*4+2] = s_tc + s_offset;
            rippleVertexes[(y*poolWidth+x)*4+3] = t_tc + t_offset;
        }
        
        [source updateAttributeBuffer];
    });
    
    float *pTmp = rippleDest;
    rippleDest = rippleSource;
    rippleSource = pTmp;
}

-(void)createRippleAtPos:(GLKVector2)position
{
    NSUInteger poolWidth = poolSize.x;
    NSUInteger poolHeight = poolSize.y;
    unsigned int xIndex = (unsigned int)(position.x / meshFactor);
    unsigned int yIndex = (unsigned int)(position.y / meshFactor);
    
    for (int y=(int)yIndex-(int)radius; y<=(int)yIndex+(int)radius; y++)
    {
        for (int x=(int)xIndex-(int)radius; x<=(int)xIndex+(int)radius; x++)
        {
            if (x>=0 && x<poolWidth &&
                y>=0 && y<poolHeight)
            {
                // +1 to both x/y values because the border is padded
                rippleSource[(poolWidth+2)*(y+1)+x+1] += rippleCoeff[(y-(yIndex-radius))*(radius*2+1)+x-(xIndex-radius)];
            }
        }
    }
}

@end
