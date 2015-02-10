//
//  IPaGLWavefrontObj.h
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPaGLRenderSource.h"
#import <GLKit/GLKit.h>
@class IPaGLWavefrontObjRenderer;
@interface IPaGLWavefrontObj : IPaGLRenderSource
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,strong) NSDictionary *materials;
@property (nonatomic,strong) NSMutableArray *renderGroup;
@property (nonatomic,strong) IPaGLWavefrontObjRenderer *renderer;
-(IPaGLWavefrontObj*)initWithFilePath:(NSString*)filePath renderer:(IPaGLWavefrontObjRenderer*)useRenderer;
- (void)render;
@end

