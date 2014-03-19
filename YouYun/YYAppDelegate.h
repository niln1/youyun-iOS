//
//  YYAppDelegate.h
//  YouYun
//
//  Created by Ranchao Zhang on 2/28/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerViewController.h>

#import "YYUser.h"
#import "YYLoginViewController.h"

@interface YYAppDelegate : UIResponder <UIApplicationDelegate, MSDynamicsDrawerViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MSDynamicsDrawerViewController *drawer;
@property (strong, nonatomic) YYUser *user;

@end
