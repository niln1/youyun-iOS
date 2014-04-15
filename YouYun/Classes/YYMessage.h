//
//  YYMessage.h
//  YouYun
//
//  Created by Ranchao Zhang on 4/13/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SIAlertView/SIAlertView.h>

@interface YYMessage : NSObject

+ (void)show:(NSString *) message withTitle:(NSString *) title andCallback:(void (^) (void)) callback;

@end
