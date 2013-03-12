//
//  IPaGLSprite2D.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/7.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLSprite2D.h"
#import "IPaGLRenderer.h"
#import "IPaGLSprite2DRenderer.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
#import "IPaGLRenderSource.h"
@interface IPaGLSprite2D ()

@property (nonatomic,weak) IPaGLRenderSource *source;
@end
@implementation IPaGLSprite2D
{
    

}
static IPaGLRenderSource *sprite2DSource = nil;
static NSUInteger sprite2DCounter = 0;
+(IPaGLRenderSource*)IPaGLSprite2DSource
{
    if (sprite2DSource == nil) {
        sprite2DSource = [[IPaGLRenderSource alloc] init];
        GLfloat VertexData[] = {
            //底
            -1,-1,0,0,
            1,-1,1,0,
            -1,1,0,1,
            1,1,1,1,
        };
        sprite2DSource.vertexAttributes = malloc(sizeof(VertexData));
        memcpy(sprite2DSource.vertexAttributes, VertexData, sizeof(VertexData));
        sprite2DSource.vertexAttributeCount = 4;
        sprite2DSource.attrHasPosZ = NO;
        sprite2DSource.attrHasNormal = NO;
        sprite2DSource.attrHasTexCoords = YES;
        [sprite2DSource createBuffer];
    }
    return sprite2DSource;

}
-(id)init
{
    if (self = [super init]) {
        sprite2DCounter++;
        self.source = [IPaGLSprite2D IPaGLSprite2DSource];
        self.material = [[IPaGLMaterial alloc] init];
    }
    return self;
}
-(id)initWithUIImage:(UIImage*)image withName:(NSString*)name
{
    self = [self init];
    
    self.material.texture = [IPaGLTexture textureFromImage:image withName:name];
    
    
    return self;
}
-(void)dealloc
{
    sprite2DCounter--;
    if (sprite2DCounter <= 0) {
        sprite2DSource = nil;
    }
    [self.material releaseResource];
}
-(void)setPosition:(GLKVector2)position
{
    _position = position;
    [self refreshMatrix];    
}
-(void)setSize:(GLKVector2)size
{
    _size = size;
    [self refreshMatrix];
}
-(void)setPosition:(GLKVector2)position size:(GLKVector2)size
{
    _position = position;
    _size = size;
    [self refreshMatrix];
}
-(void)refreshMatrix
{
 
    GLKVector2 displaySizeRatio = self.renderer.displaySizeRatio;
    _matrix = GLKMatrix4MakeTranslation(-1 + (self.size.x + self.position.x * 2) * displaySizeRatio.x,1 - (self.size.y + self.position.y * 2) * displaySizeRatio.y, 0);
    
    //    改到這裡，
    _matrix = GLKMatrix4Scale(_matrix, self.size.x * displaySizeRatio.x, self.size.y * displaySizeRatio.y, 1);
    
}

-(void)setTexture:(IPaGLTexture*)texture
{
    self.material.texture = texture;
}
-(void)render
{
    [self.renderer setModelViewMatrix:self.matrix];
    [self.source renderWithRenderer:self.renderer];
    
    [self.renderer prepareToRenderWithMaterial:self.material];
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
@end
