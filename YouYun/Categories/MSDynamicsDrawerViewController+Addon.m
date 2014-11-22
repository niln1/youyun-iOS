//
//  MSDynamicsDrawerViewController+Addon.m
//  YouYun
//
//  Created by Zhihao Ni on 11/21/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import "MSDynamicsDrawerViewController+Addon.h"

@implementation MSDynamicsDrawerViewController (Addon)

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    if ([panGestureRecognizer isKindOfClass: [UIPanGestureRecognizer class]]) {
        CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
        if (self.paneState == MSDynamicsDrawerPaneStateClosed) {
            return velocity.x > 0;
        } else {
            return velocity.x < 0;
        }
    } else {
        return true;
    }
}

@end
