//
//  UIView+Addon.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/15/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "UIView+Addon.h"

@implementation UIView (Addon)

- (void)setBorderRadius:(CGFloat) radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat) width
{
    self.layer.borderWidth = width;
}

- (void)setBorderColor:(UIColor *)color
{
    self.layer.borderColor = [color CGColor];
}

@end
