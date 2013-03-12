//
//  FramebufferTextureSampleViewController.h
//  IPaGLObjectSample
//
//  Created by IPaPa on 13/3/11.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface FramebufferTextureSampleViewController : GLKViewController
{
    IBOutlet UIButton *bBtn;
    
    IBOutlet UIButton *wBtn;
}
- (IBAction)onSelectWhite:(id)sender;
- (IBAction)onSelectBlack:(id)sender;
- (IBAction)onClear:(id)sender;

@end
