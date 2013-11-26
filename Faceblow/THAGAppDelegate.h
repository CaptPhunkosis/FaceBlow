//
//  THAGAppDelegate.h
//  Faceblow
//
//  Created by nick on 11/23/13.
//  Copyright (c) 2013 Thag Industries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THAGMainViewController.h"

@interface THAGAppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly) THAGMainViewController *mainViewController;
@property (strong, nonatomic) UIWindow *window;

@end