//
//  YYUser.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/10/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYUser.h"

@interface YYUser ()

@property (nonatomic) YYUserType type;
@property (nonatomic, retain) NSString *name;

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
        _type = YYUserTypeAdmin;
        _name = @"";
    }
    return self;
}

- (NSString *) typeKey {
    switch (_type) {
        case YYUserTypeAdmin: return @"admin";
        case YYUserTypeParent: return @"parent";
        case YYUserTypeStudent: return @"student";
        case YYUserTypeTeacher: return @"teacher";
    }
}

- (void)isUserLoggedIn:(void (^) (BOOL userLoggedIn, NSInteger statusCode)) callback
{
    [[YYHTTPManager I] GET:GET_ACCOUNT_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSHTTPURLResponse *response = operation.response;
        callback(YES, response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        callback(NO, response.statusCode);
    }];
}

- (void)loginWithUsername:(NSString *) username andPassword:(NSString *) password
{
    // TODO
    _type = YYUserTypeAdmin;
    _name = @"Ranchao Zhang";
}

- (void)logout
{
    
}

@end
