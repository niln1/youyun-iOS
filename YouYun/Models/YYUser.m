//
//  YYUser.m
//  YouYun
//
//  Created by Zhihao Ni and Ranchao Zhang on 3/10/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import "YYUser.h"

@interface YYUser ()

@end

@implementation YYUser

static YYUser *instance;

+ (YYUser *)I
{
    if (instance == nil) {
		static dispatch_once_t pred;
		dispatch_once(&pred, ^{
            instance = [YYUser new];
        });
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        // TODO
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME_KEY];
        NSNumber *userType = [[NSUserDefaults standardUserDefaults] objectForKey:USER_TYPE_KEY];
        _userID = userID ? userID : @"";
        _userType = userType ? [userType boolValue] : YYUserTypeStudent;
        _username = username ? username : @"";
    }
    return self;
}

- (NSString *) typeKey {
    switch (_userType) {
        case YYUserTypeAdmin: return @"admin";
        case YYUserTypeSchool: return @"school";
        case YYUserTypeTeacher: return @"teacher";
        case YYUserTypeStudent: return @"student";
        case YYUserTypeParent: return @"parent";
        case YYUserTypeAlumni: return @"alumni";
    }
}

- (void)setUserID:(NSString *)userID
{
    _userID = userID;
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_ID_KEY];
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:USERNAME_KEY];
}

- (void)setUserType:(YYUserType)userType
{
    _userType = userType;
    [[NSUserDefaults standardUserDefaults] setObject:@(userType) forKey:USER_TYPE_KEY];
    
}

- (void)isUserLoggedIn:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback
{
    [[YYHTTPManager I] GET:GET_ACCOUNT_API withURLEncodedParameters:@{@"signature" : @"tempkey"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        OLog(responseObject);
        [self parseLoginResponse:responseObject withOperation:operation andCallback:callback];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        callback(NO, response.statusCode, [NSError errorWithDomain:GET_ACCOUNT_API code:response.statusCode userInfo:@{@"operation" : operation}]);
    }];
}

- (void)loginWithUsername:(NSString *) username andPassword:(NSString *) password withCallback:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback;
{
    NSDictionary *formData = @{@"username" : username,
                               @"password" : password};
    
    [[YYHTTPManager I] POST:LOGIN_API_PATH withFormParameters:formData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        OLog(responseObject);
        [self parseLoginResponse:responseObject withOperation:operation andCallback:^(BOOL userLoggedIn, NSInteger statusCode, NSError *error) {
            if (userLoggedIn) {
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOG_IN_NOTIFICATION object:nil];
                
            }
            callback(userLoggedIn, statusCode, error);
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        callback(NO, response.statusCode, [NSError errorWithDomain:GET_ACCOUNT_API code:response.statusCode userInfo:@{@"operation" : operation}]);
    }];
}

- (void)parseLoginResponse:(id) responseObject withOperation:(AFHTTPRequestOperation *) operation andCallback:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback
{
    NSHTTPURLResponse *response = operation.response;
    @try {
        NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"Login response should be a JSON dictionary.");
        NSAssert(responseObject[@"result"] && responseObject[@"result"][@"_id"] && responseObject[@"result"][@"username"] && responseObject[@"result"][@"userType"] && [responseObject[@"result"][@"userType"] isKindOfClass:[NSNumber class]], @"Login response have name and permission level.");
        NSInteger userType = [responseObject[@"result"][@"userType"] integerValue];
        NSAssert(userType >= 0 && userType < 6, @"Login response should have user type in range.");
        _userID = responseObject[@"result"][@"_id"];
        _username = responseObject[@"result"][@"username"];
        _userType = (YYUserType) userType;
        callback(YES, response.statusCode, nil);
    }
    @catch (NSException *exception) {
        NSString *errorMsg = responseObject[@"description"] ? responseObject[@"description"] : @"Login response invalid.";
        callback(NO, response.statusCode, [NSError errorWithDomain:GET_ACCOUNT_API code:response.statusCode userInfo:@{@"result" : errorMsg}]);
    }
}

- (void)logout
{
    [[YYHTTPManager I] GET:LOGOUT_API_PATH withURLEncodedParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_SESSION_INVALID_NOTIFICATION object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
