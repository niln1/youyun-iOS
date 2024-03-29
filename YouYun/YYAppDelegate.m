//
//  YYAppDelegate.m
//  YouYun
//
//  Created by Zhihao Ni & Ranchao Zhang on 2/28/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import "YYAppDelegate.h"

@implementation YYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // UI setup
    [[UISwitch appearance] setTintColor:SCHOOL_DARK_COLOR];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // Cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    // Register for push notifications
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    // Assign root view controller
    UINavigationController *navi = (UINavigationController *) self.window.rootViewController;
    _drawer = (MSDynamicsDrawerViewController *) navi.viewControllers[0];
    
    // Set style for dynamics drawer
    [_drawer addStylersFromArray:@[[MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler], [MSDynamicsDrawerParallaxStyler styler],[MSDynamicsDrawerResizeStyler styler], [MSDynamicsDrawerShadowStyler styler]] forDirection:MSDynamicsDrawerDirectionHorizontal];
    
    // Set delegate for drawer
    _drawer.delegate = self;
    
    // Set menu view controller for drawer
    _menu = [_drawer.storyboard instantiateViewControllerWithIdentifier:[YYMenuViewController identifier]];
    [_drawer setDrawerViewController:_menu forDirection:MSDynamicsDrawerDirectionLeft];
    _menu.drawer = _drawer;
    [_menu loadInitialMenuItem];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :SCHOOL_VERY_LIGHT_COLOR} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTintColor:SCHOOL_VERY_LIGHT_COLOR];
    
    // SIAlertView
    [[SIAlertView appearance] setDestructiveButtonColor:SCHOOL_COLOR];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewController) name:USER_SESSION_INVALID_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMenu) name:USER_LOG_IN_NOTIFICATION object:nil];
    
    [[YYUser I] isUserLoggedIn:^(BOOL userLoggedIn, NSInteger statusCode, NSError *error) {
        if (!userLoggedIn) {
            [self showLoginViewController];
        } else {
            [self reloadMenu];
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *str = [NSString stringWithFormat:@"Device Token=%@",deviceTokenString];
    [[YYUser I] addDeviceToken:deviceTokenString];
    DLog(@"%@", str);
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"APNS Error: %@", err];
    DLog(@"%@", str);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    for (id key in userInfo) {
        DLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
}

- (void)showLoginViewController
{
    if (![[_drawer.navigationController visibleViewController] isMemberOfClass:[YYLoginViewController class]]) {
        YYLoginViewController *login = [_drawer.storyboard instantiateViewControllerWithIdentifier:[YYLoginViewController identifier]];
        OLog([YYLoginViewController identifier]);
        [_drawer.navigationController presentViewController:login animated:YES completion:nil];
    }
}

- (void)reloadMenu
{
    [_menu reload];
}

@end
