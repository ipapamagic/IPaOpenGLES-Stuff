//
//  IPaWavefrontGroup.h
//  IPaWavefrontObject
//
//  Created by IPaPa on 13/1/8.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class IPaWavefrontMaterial;
@interface IPaWavefrontGroup : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) GLushort *vertexIndexes;
@property (nonatomic, assign) NSUInteger indexNumber;
@property (nonatomic, weak) IPaWavefrontMaterial *material;

- (id)initWithName:(NSString *)inName;
-(void)createBuffer;
-(void)renderWithGLKBaseEffect:(GLKBaseEffect*)glkEffect;
@end
