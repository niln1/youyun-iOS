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
#import "YYLoginViewController.h"
#import "YYUser.h"

@interface YYMenuViewController : UIViewController

@property (nonatomic, weak) MSDynamicsDrawerViewController *drawer;

@property (nonatomic, retain) NSDictionary *moduleIdentifiers;
@property (nonatomic, retain) NSArray *menuItems;
@property (nonatomic, retain) NSDictionary *selectedMenuItem;

- (void)loadInitialMenuItem;
- (void)loadMenuItemAtIndex:(NSInteger) index;

@end
