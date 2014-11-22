//
//  MSDynamicsDrawerViewController+Addon.m
//  YouYun
//
//  Created by Zhihao Ni on 11/21/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import "MSDynamicsDrawerViewController+Addon.h"

@implementation MSDynamicsDrawerViewController (Addon)

// fix gesture for cell
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
