//
//  YYUser.h
//  YouYun
//
//  Created by Ranchao Zhang on 3/10/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYVariables.h"
#import "YYHTTPManager.h"

@class YYHTTPManager;

static NSString *USER_SESSION_INVALID_NOTIFICATION = @"USER_SESSION_INVALID_NOTIFICATION";

typedef NS_ENUM(NSInteger, YYUserType) {
    YYUserTypeAdmin,
    YYUserTypeSchool,
    YYUserTypeTeacher,
    YYUserTypeStudent,
    YYUserTypeParent,
    YYUserTypeAlumni
};

@interface YYUser : NSObject

+ (YYUser *)I;
- (NSString *) typeKey;
- (void)isUserLoggedIn:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback;
- (void)loginWithUsername:(NSString *) username andPassword:(NSString *) password withCallback:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback;
- (void)logout;

@end
