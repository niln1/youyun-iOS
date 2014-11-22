//
//  YYAppDelegate.h
//  YouYun
//
//  Created by Zhihao Ni on 2/28/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SIAlertView/SIAlertView.h>
#import "MSDynamicsDrawerViewController+Addon.h"
#import "YYUser.h"
#import "YYLoginViewController.h"
#import "YYMenuViewController.h"

@interface YYAppDelegate : UIResponder <UIApplicationDelegate, MSDynamicsDrawerViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MSDynamicsDrawerViewController *drawer;
@property (strong, nonatomic) YYMenuViewController *menu;
@property (strong, nonatomic) YYUser *user;

- (void)reloadMenu;

@end
