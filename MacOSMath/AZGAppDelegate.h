//
//  AZGAppDelegate.h
//  MacOSMath
//
//  Created by 安志钢 on 17-01-06.
//  Copyright (c) 2017年 安志钢. All rights reserved.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import <Cocoa/Cocoa.h>
#import "MacOSMath.h"

@interface AZGAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet MTMathUILabel *mathLabel;
@property (assign) IBOutlet NSTextField *input;

@end
