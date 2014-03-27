//
//  YYAppDelegate.m
//  YouYun
//
//  Created by Ranchao Zhang on 2/28/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYAppDelegate.h"

@implementation YYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Assign root view controller
    UINavigationController *navi = (UINavigationController *) self.window.rootViewController;
    _drawer = (MSDynamicsDrawerViewController *) navi.viewControllers[0];
    
    // Set style for dynamics drawer
    [_drawer addStylersFromArray:@[[MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler], [MSDynamicsDrawerParallaxStyler styler],[MSDynamicsDrawerResizeStyler styler], [MSDynamicsDrawerShadowStyler styler]] forDirection:MSDynamicsDrawerDirectionHorizontal];
    
    // Set delegate for drawer
    _drawer.delegate = self;
    
    // Set menu view controller for drawer
    YYMenuViewController *menu = [_drawer.storyboard instantiateViewControllerWithIdentifier:[YYMenuViewController identifier]];
    [_drawer setDrawerViewController:menu forDirection:MSDynamicsDrawerDirectionLeft];
    menu.drawer = _drawer;
    [menu loadInitialMenuItem];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    if (!YYUser.I.isLoggedIn && ![[_drawer.navigationController visibleViewController] isMemberOfClass:[YYLoginViewController class]]) {
        YYLoginViewController *login = [_drawer.storyboard instantiateViewControllerWithIdentifier:[YYLoginViewController identifier]];
        OLog([YYLoginViewController identifier]);
        [_drawer.navigationController presentViewController:login animated:YES completion:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
