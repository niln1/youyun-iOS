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
        case YYUserTypeSchool: return @"school";
        case YYUserTypeTeacher: return @"teacher";
        case YYUserTypeStudent: return @"student";
        case YYUserTypeParent: return @"parent";
        case YYUserTypeAlumni: return @"alumni";
    }
}

- (void)isUserLoggedIn:(void (^) (BOOL userLoggedIn, NSInteger statusCode, NSError *error)) callback
{
    [[YYHTTPManager I] GET:GET_ACCOUNT_API withURLEncodedParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        [self parseLoginResponse:responseObject withOperation:operation andCallback:callback];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_SESSION_INVALID_NOTIFICATION object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
