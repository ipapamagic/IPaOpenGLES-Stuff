//
//  IPaGLGooEffect.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/24.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLGooEffect.h"
#import "IPaGLGooRenderer.h"
@implementation IPaGLGooEffect
{
 
    NSUInteger radius;
    IPaGLFramebufferTexture *gooTexture;
    IPaGLGooRenderer *gooRenderer;

}
-(id)initWithSize:(GLKVector2)size meshFactor:(NSUInteger)factor gooRadius:(NSUInteger)gooRadius
{
    self = [super initWithSize:size meshFactor:factor];
    radius = gooRadius;
    
    gooTexture = [[IPaGLFramebufferTexture alloc] initWithSize:CGSizeMake(size.x, size.y)];
    gooRenderer = [[IPaGLGooRenderer alloc] init];
    gooRenderer.matrix = GLKMatrix4MakeTranslation(size.x * 0.5, size.y * 0.5, 0);
    gooRenderer.matrix = GLKMatrix4Scale(gooRenderer.matrix, size.x * 0.5, -size.y * 0.5, 1);

    return self;
}
-(void)dealloc
{

}
-(void)velocityFromPos:(GLKVector2)startPos toPos:(GLKVector2)endPos
{
   
    [gooTexture bindFramebuffer];
    glDisable(GL_BLEND);
   
    
    material.texture = texture.texture;
    GLKVector2 moveVector = GLKVector2Subtract(endPos, startPos);
    gooRenderer.maxMove = MIN(meshFactor,GLKVector2Length(moveVector));
    gooRenderer.range = 50;
    gooRenderer.gooVector = GLKVector4Make(startPos.x, startPos.y, endPos.x,endPos.y);
    [source renderWithRenderer:gooRenderer];
    [vertexIndexes bindBuffer];
    [gooRenderer prepareToRenderWithMaterial:material];
    glDrawElements(GL_TRIANGLE_STRIP, vertexIndexes.indexNumber,GL_UNSIGNED_SHORT, 0);
    
    material.texture = gooTexture.texture;
    [texture bindFramebuffer];
    [source renderWithRenderer:renderer];
    [vertexIndexes bindBuffer];
    [renderer prepareToRenderWithMaterial:material];
    glDrawElements(GL_TRIANGLE_STRIP, vertexIndexes.indexNumber,GL_UNSIGNED_SHORT, 0);
    
    
}

@end
