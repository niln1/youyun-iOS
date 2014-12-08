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
    [self initializeBackgroundAndLogo];
    [self initializeButtons];
    [self initializeTextFields];
}

- (void)initializeBackgroundAndLogo
{
    _background = [[CRMotionView alloc] initWithFrame:self.view.bounds];
    UIImage *origBGImg = [UIImage imageNamed:@"LoginBG.jpg"];
    [_background setImage:origBGImg];
    [self.view insertSubview:_background atIndex:0];
    
    CALayer * layer = [_schoolLogo layer];
    [layer setMasksToBounds:NO];
    [layer setCornerRadius:_schoolLogo.bounds.size.height/2];
//    _schoolLogo.backgroundColor=SCHOOL_VERY_LIGHT_COLOR;
    
    [layer setShadowColor:SCHOOL_VERY_LIGHT_COLOR.CGColor];
    [layer setShadowOpacity:1];
    [layer setShadowRadius:20.0];
    [layer setShadowOffset:CGSizeMake(0.0, 0.0)];
}

- (void)initializeButtons
{
    _loginButton.titleLabel.font = [UIFont flatFontOfSize:14];
    [_loginButton setBackgroundColor:SCHOOL_COLOR];
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

#pragma mark - textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
