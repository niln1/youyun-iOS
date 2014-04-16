//
//  YYMessage.m
//  YouYun
//
//  Created by Ranchao Zhang on 4/13/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYMessage.h"

@implementation YYMessage

+ (void)show:(NSString *) message withTitle:(NSString *) title andCallback:(void (^) (void)) callback;
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    
    [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alert) {
        callback();
    }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
}

@end
