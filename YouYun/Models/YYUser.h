//
//  YYUser.h
//  YouYun
//
//  Created by Zhihao Ni and Ranchao Zhang on 3/10/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYVariables.h"
#import "YYHTTPManager.h"

@class YYHTTPManager;

static NSString *USER_SESSION_INVALID_NOTIFICATION = @"USER_SESSION_INVALID_NOTIFICATION";
static NSString *USER_LOG_IN_NOTIFICATION = @"USER_LOG_IN_NOTIFICATION";

static NSString *USER_ID_KEY = @"USER_ID_KEY";
static NSString *USERNAME_KEY = @"USERNAME_KEY";
static NSString *USER_TYPE_KEY = @"USER_TYPE_KEY";

typedef NS_ENUM(NSInteger, YYUserType) {
    YYUserTypeAdmin,
    YYUserTypeSchool,
    YYUserTypeTeacher,
    YYUserTypeStudent,
    YYUserTypeParent,
    YYUserTypeAlumni
};

@interface YYUser : NSObject

@property (nonatomic, retain, readonly) NSString *userID;
@property (nonatomic, retain, readonly) NSString *username;
@property (nonatomic, readonly) YYUserType userType;
@property (nonatomic, readonly) NSArray *userDevices;

+ (YYUser *)I;
- (NSString *) typeKey;
- (void)addDeviceToken:(NSString *) deviceTokenString;
- (void)isUserLoggedIn:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback;
- (void)loginWithUsername:(NSString *) username andPassword:(NSString *) password withCallback:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback;
- (void)logout;

@end
