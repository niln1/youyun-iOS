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

static NSString *LOGIN_API_PATH = @"/api/v1/account/login";

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
    [_background setImage:[UIImage imageNamed:@"LoginViewBackgroundImage"]];
    [self.view insertSubview:_background atIndex:0];
}

- (void)initializeButtons
{
    _loginButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_loginButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

- (void)initializeTextFields
{
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
    NSDictionary *formData = @{
        @"username" : @"admin",
        @"password" : @"adminpw"
    };
    
    [[YYHTTPManager I] POST:LOGIN_API_PATH parameters:formData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"success");
        OLog(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"failure");
        _passwordField.layer.borderColor=[[UIColor alizarinColor] CGColor];
        [_passwordField shake:10 withDelta:5 andSpeed:0.03 shakeDirection:ShakeDirectionHorizontal];
        OLog(error);
    }];
}

@end
