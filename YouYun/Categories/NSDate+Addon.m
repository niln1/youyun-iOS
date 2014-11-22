//
//  NSDate+Addon.m
//  YouYun
//
//  Created by Zhihao Ni on 7/30/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import "NSDate+Addon.h"

@implementation NSDate (Addon)

+ (NSDate *)dateForJSTimeString:(NSString *)rfc3339DateTimeString {
    
	NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    
	[rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
	[rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
	NSDate *result = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
	return result;
}

@end
