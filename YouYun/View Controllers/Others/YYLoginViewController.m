//
//  YYLoginViewController.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/10/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYLoginViewController.h"

@interface YYLoginViewController ()

@end

@implementation YYLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initialize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialize
{
    [self initializeBackground];
    [self initializeButtons];
    [self initializeTextFields];
}

- (void)initializeBackground
{
    _background = [[CRMotionView alloc] initWithFrame:self.view.bounds];
    UIImage *origBGImg = [UIImage imageNamed:@"LoginViewBackgroundImage"];
    UIImage *blurBGImg = [origBGImg stackBlur:20];
    [_background setImage:blurBGImg];
    [self.view insertSubview:_background atIndex:0];
}

- (void)initializeButtons
{
    _loginButton.titleLabel.font = [UIFont flatFontOfSize:14];
    [_loginButton setBackgroundColor:UI_COLOR];
    [_loginButton setTintColor:[UIColor whiteColor]];
    [_loginButton setShowsTouchWhenHighlighted:YES];
    [_loginButton setBorderRadius:UI_CORNER_RADIUS];
}

- (void)initializeTextFields
{
    _usernameField.font = [UIFont flatFontOfSize:14];
    _passwordField.font = [UIFont flatFontOfSize:14];
}

#pragma mark - Overwrite methods to control rotation
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - IBActions

- (IBAction)loginButtonClicked:(id)sender
{
    [[YYUser I] loginWithUsername:_usernameField.text andPassword:_passwordField.text withCallback:^(BOOL userLoggedIn, NSInteger statusCode, NSError *error) {
        if (userLoggedIn) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            _passwordField.layer.borderColor=[[UIColor alizarinColor] CGColor];
            [_passwordField shake:10 withDelta:5 andSpeed:0.03 shakeDirection:ShakeDirectionHorizontal];
        }
    }];
}

@end
