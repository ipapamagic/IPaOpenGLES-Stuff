//
//  IPaGLGooEffect.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/24.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLGooEffect.h"

@implementation IPaGLGooEffect
{
// 
//    IPaGLFramebufferTexture *gooTexture;
//    IPaGLGooRenderer *gooRenderer;

}
-(id)initWithSize:(GLKVector2)size meshFactor:(NSUInteger)factor gooRadius:(NSUInteger)gooRadius
{
    self = [super initWithSize:size meshFactor:factor];
    
//    gooTexture = [[IPaGLFramebufferTexture alloc] initWithSize:CGSizeMake(size.x, size.y) filter:GL_LINEAR];
//    gooRenderer = [[IPaGLGooRenderer alloc] init];
//    gooRenderer.matrix = GLKMatrix4MakeTranslation(size.x * 0.5, size.y * 0.5, 0);
//    gooRenderer.matrix = GLKMatrix4Scale(gooRenderer.matrix, size.x * 0.5, -size.y * 0.5, 1);
    return self;
}
-(void)dealloc
{

}
-(void)velocityFromPos:(GLKVector2)startPos toPos:(GLKVector2)endPos
{
    
    GLfloat *vertexAttribute = source.vertexAttributes;
    GLKVector2 size = self.displaySize;
    GLKMatrix4 matrix = GLKMatrix4MakeTranslation(size.x * 0.5, size.y * 0.5, 0);
    bool isInvertible;
 
    matrix = GLKMatrix4Scale(matrix, size.x * 0.5, -size.y * 0.5, 1);
   GLKMatrix4 inverseMatrix = GLKMatrix4Invert(matrix, &isInvertible);    
    GLKVector2 velocityVec = GLKVector2Subtract(endPos, startPos);
    GLfloat velocityLength = GLKVector2Length(velocityVec);
    if (velocityLength == 0) {
        return;
    }
    GLKVector2 velocityNormalVec = GLKVector2Normalize(velocityVec);
    GLKVector2 moveVec = GLKVector2MultiplyScalar(velocityNormalVec, velocityLength * 0.1);
    NSUInteger poolWidth = poolSize.x;
    NSUInteger poolHeight = poolSize.y;
    
    GLfloat maxRange = 80;
    for (NSUInteger y = 1; y < poolHeight-1; y ++) {
        for (NSUInteger x = 1; x < poolWidth-1; x++) {
            NSUInteger idx = (y * poolWidth + x) * 4;
            GLKVector2 overtex = GLKVector2Make(vertexAttribute[idx], vertexAttribute[idx + 1]);
            GLKVector3 vertex = GLKMatrix4MultiplyVector3WithTranslation(matrix, GLKVector3Make(overtex.x, overtex.y, 1));
            
            GLKVector2 vertexVec = GLKVector2Make(vertex.x - startPos.x, vertex.y - startPos.y);
            GLfloat vertexLength = GLKVector2Length(vertexVec);
            
            if (vertexLength > maxRange) {
                continue;
            }
            
            vertex.x += moveVec.x;
            vertex.y += moveVec.y;
            GLKVector3 newVertex = GLKMatrix4MultiplyVector3WithTranslation(inverseMatrix, vertex);
            
            vertexAttribute[idx] = newVertex.x;
            vertexAttribute[idx + 1] = newVertex.y;
            continue;
            
            
//            
//            
//            GLKVector2 vertexVec = GLKVector2Make(vertex.x - endPos.x, vertex.y - endPos.y);
//            GLfloat vertexLength = GLKVector2Length(vertexVec);
//           
//            
//            
//            
//            GLfloat cos = GLKVector2DotProduct(velocityVec, vertexVec) / velocityLength / vertexLength;
//            if (cos > 0) {
//                //behind endPos
//
//                
//                continue;
//            }
//            
//            vertexVec = GLKVector2Make(vertex.x - startPos.x, vertex.y - startPos.y);
//            cos = GLKVector2DotProduct(velocityVec, vertexVec) / velocityLength / GLKVector2Length(vertexVec);
//            if (cos <= 0) {
//                //before startPos
//                continue;
//            }
//            
//            moveVec = GLKVector2MultiplyScalar(velocityNormalVec, vertexLength * cos);
//            GLKVector2 projVec = GLKVector2Subtract( vertexVec ,moveVec);
//            GLfloat projLength = GLKVector2Length(projVec);
//            GLfloat scalar = MAX(0,(maxRange - projLength)/maxRange);
//            
//            if (scalar > 0) {
//                moveVec = GLKVector2MultiplyScalar(velocityNormalVec, scalar*velocityLength * 0.8 );
//                vertex.x += moveVec.x;
//                vertex.y += moveVec.y;
//                GLKVector3 newVertex = GLKMatrix4MultiplyVector3WithTranslation(inverseMatrix, vertex);
//
//                vertexAttribute[idx] = newVertex.x;
//                vertexAttribute[idx + 1] = newVertex.y;
//            }
            
        }
    }
    [source updateAttributeBuffer];
        

    
    
//    {
//        [gooTexture bindFramebuffer];
//        glDisable(GL_BLEND);
//        glClearColor(0.0, 0.0, 1.0, 1);
//        glClear(GL_COLOR_BUFFER_BIT);
//        
//        material.texture = texture.texture;
//
//        gooRenderer.ratio = 1;
//
//        gooRenderer.gooVector = GLKVector4Make(startPos.x, startPos.y, endPos.x,endPos.y);
//        [source renderWithRenderer:gooRenderer];
//        [vertexIndexes bindBuffer];
//        [gooRenderer prepareToRenderWithMaterial:material];
//        //glDrawElements(GL_TRIANGLE_STRIP, vertexIndexes.indexNumber,GL_UNSIGNED_SHORT, 0);
//        glDrawArrays(GL_POINTS, 0, source.vertexAttributeCount);
//        
//        
//        
//        material.texture = gooTexture.texture;
//        [texture bindFramebuffer];
//
//        
//        [source renderWithRenderer:renderer];
//        [vertexIndexes bindBuffer];
//        [renderer prepareToRenderWithMaterial:material];
//        glDrawElements(GL_TRIANGLE_STRIP, vertexIndexes.indexNumber,GL_UNSIGNED_SHORT, 0);
//    }
}

@end
