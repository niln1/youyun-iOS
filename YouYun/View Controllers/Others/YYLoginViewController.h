//
//  YYLoginViewController.h
//  YouYun
//
//  Created by Ranchao Zhang on 3/10/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CRMotionView/CRMotionView.h>
#import <UITextField+Shake/UITextField+Shake.h>
#import <QuartzCore/QuartzCore.h>
#import <StackBluriOS/UIImage+StackBlur.h>
#import "FlatUIKit.h"
#import "UIView+Addon.h"
#import "YYHTTPManager.h"
#import "YYUser.h"
#import "YYVariables.h"

@class YYAppDelegate;

@interface YYLoginViewController : UIViewController

@property (nonatomic, retain) CRMotionView *background;
@property (nonatomic, weak) IBOutlet UIImageView *schoolLogo;
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonClicked:(id)sender;

@end
