//
//  MLNavigationController.m
//  MusicLunatic
//
//  Created by Ranchao Zhang on 6/13/13.
//  Copyright (c) 2013 Ranchao Zhang. All rights reserved.
//

#import "YYNavigationController.h"

@interface YYNavigationController ()

@end

@implementation YYNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Enable swipe to pop for portrait view
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Enable swipe to pop for portrait view

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count > 1) {
        UIViewController *view = [self.viewControllers lastObject];
        if ([view conformsToProtocol:@protocol(YYSwipeToPopViewController)]) {
            return [(id<YYSwipeToPopViewController>) view shouldAllowSwipeToPop];
        }
        
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Overwrite methods to control rotation
- (BOOL)prefersStatusBarHidden
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
