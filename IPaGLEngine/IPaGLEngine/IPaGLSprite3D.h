//
//  IPaGLSprite3D.h
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/30.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLEntity.h"
#import "IPaGLSprite3DRenderer.h"
@class IPaGLMaterial;
@interface IPaGLSprite3D : IPaGLEntity
@property (nonatomic,strong) IPaGLMaterial* material;
@property (nonatomic,strong) IPaGLSprite3DRenderer *renderer;
@property (nonatomic,assign) GLKVector2 size;
-(id)initWithUIImage:(UIImage*)image withName:(NSString*)name renderer:(IPaGLSprite3DRenderer*) useRenderer;
@end
