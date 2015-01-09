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
@interface IPaGLWavefrontObj : IPaGLRenderSource
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,strong) NSDictionary *materials;
@property (nonatomic,strong) NSMutableArray *renderGroup;
-(IPaGLWavefrontObj*)initWithFilePath:(NSString*)filePath;
@end

