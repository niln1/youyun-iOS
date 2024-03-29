//
//  YYMenuViewController.h
//  YouYun
//
//  Created by Ranchao Zhang on 2/28/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerViewController.h>
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerViewController.h>
#import <MDCParallaxView/MDCParallaxView.h>
#import "FAKIonIcons.h"
#import "YYLoginViewController.h"
#import "YYNavigationController.h"
#import "YYUser.h"

#define LOGOUT_MENU_ITEM @"Log Out"

@interface YYMenuViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIButton *userButton;

@property (nonatomic, weak) MSDynamicsDrawerViewController *drawer;

@property (nonatomic, retain) NSDictionary *moduleIdentifiers;
@property (nonatomic, retain) NSArray *menuItems;
@property (nonatomic, retain) NSDictionary *selectedMenuItem;

- (void)reload;
- (void)loadInitialMenuItem;
- (void)loadMenuItemAtIndex:(NSInteger) index;

@end
