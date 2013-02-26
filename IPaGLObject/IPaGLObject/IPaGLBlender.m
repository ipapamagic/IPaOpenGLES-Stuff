//
//  IPaGLBlender.m
//  IPaGLObject
//
//  Created by IPaPa on 13/2/22.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLBlender.h"
@interface IPaGLBlender () <NSCopying>
@end
@implementation IPaGLBlender
-(void)bindBlendFunc
{
    glEnable(GL_BLEND);
    glBlendFunc(self.sfactor, self.dfactor);

}
#pragma mark - NSCopying protocol
-(id)copyWithZone:(NSZone *)zone
{
    IPaGLBlender *newBlender = [super copy];
    newBlender.sfactor = self.sfactor;
    newBlender.dfactor = self.dfactor;
    return newBlender;
}

@end
