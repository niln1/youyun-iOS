//
//  YYUser.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/10/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYUser.h"

@interface YYUser ()

@property (nonatomic) YYUserType userType;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *userID;

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
        _userType = YYUserTypeAdmin;
        _username = @"";
        _userID = @"";
    }
    return self;
}

- (NSString *) typeKey {
    switch (_userType) {
        case YYUserTypeAdmin: return @"admin";
        case YYUserTypeParent: return @"parent";
        case YYUserTypeStudent: return @"student";
        case YYUserTypeTeacher: return @"teacher";
        default: return nil;
    }
}

- (void)isUserLoggedIn:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback
{
    [[YYHTTPManager I] GET:GET_ACCOUNT_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseLoginResponse:responseObject withOperation:operation andCallback:callback];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        id responseObject = operation.responseObject;
        NSString *errorMsg = responseObject[@"description"] ? responseObject[@"description"] : @"Login response invalid.";
        callback(NO, response.statusCode, [NSError errorWithDomain:GET_ACCOUNT_API code:response.statusCode userInfo:@{@"message" : errorMsg}]);
    }];
}

- (void)loginWithUsername:(NSString *) username andPassword:(NSString *) password withCallback:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback;
{
    NSDictionary *formData = @{@"username" : username,
                               @"password" : password};
    
    [[YYHTTPManager I] POST:LOGIN_API_PATH parameters:formData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseLoginResponse:responseObject withOperation:operation andCallback:callback];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        id responseObject = operation.responseObject;
        NSString *errorMsg = responseObject[@"description"] ? responseObject[@"description"] : @"Login response invalid.";
        callback(NO, response.statusCode, [NSError errorWithDomain:LOGIN_API_PATH code:response.statusCode userInfo:@{@"message" : errorMsg}]);
    }];
}

- (void)parseLoginResponse:(id) responseObject withOperation:(AFHTTPRequestOperation *) operation andCallback:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback
{
    NSHTTPURLResponse *response = operation.response;
    @try {
        NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"Login response should be a JSON dictionary.");
        NSAssert(responseObject[@"message"] && responseObject[@"message"][@"_id"] && responseObject[@"message"][@"username"] && responseObject[@"message"][@"userType"] && [responseObject[@"message"][@"userType"] isKindOfClass:[NSNumber class]], @"Login response have name and permission level.");
        NSInteger userType = [responseObject[@"message"][@"userType"] integerValue];
        NSAssert(userType >= 0 && userType < 6, @"Login response should have user type in range.");
        _userID = responseObject[@"message"][@"_id"];
        _username = responseObject[@"message"][@"username"];
        _userType = (YYUserType) userType;
        callback(YES, response.statusCode, nil);
    }
    @catch (NSException *exception) {
        NSString *errorMsg = responseObject[@"description"] ? responseObject[@"description"] : @"Login response invalid.";
        callback(NO, response.statusCode, [NSError errorWithDomain:GET_ACCOUNT_API code:response.statusCode userInfo:@{@"message" : errorMsg}]);
    }
}

- (void)logout
{
    [[YYHTTPManager I] GET:LOGOUT_API_PATH parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_SESSION_INVALID_NOTIFICATION object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
