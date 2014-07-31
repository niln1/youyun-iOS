//
//  NSDate+Addon.h
//  YouYun
//
//  Created by Ranchao Zhang on 7/30/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addon)

+ (NSDate *)dateForJSTimeString:(NSString *)rfc3339DateTimeString;
@end
