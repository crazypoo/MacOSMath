//
//  AZGAppDelegate.m
//  MacOSMath
//
//  Created by 安志钢 on 17-01-06.
//  Copyright (c) 2017年 安志钢. All rights reserved.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "AZGAppDelegate.h"

@implementation AZGAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)clickUpdate:(NSButton *)sender
{
    self.mathLabel.latex = self.input.stringValue;
}

@end
