//
//  UIViewController+Addon.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/11/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "UIViewController+Addon.h"

@implementation UIViewController (Addon)

+ (NSString *)identifier
{
    return [[self class] description];
}

@end
