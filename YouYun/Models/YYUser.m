//
//  YYUser.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/10/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYUser.h"

@interface YYUser ()

@property (nonatomic) BOOL loggedIn;
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
        _loggedIn = NO;
        _type = YYUserTypeAdmin;
        _name = @"";
    }
    return self;
}

- (BOOL)isLoggedIn
{
    return self.isLoggedIn;
}

- (void)loginWithUsername:(NSString *) username andPassword:(NSString *) password
{
    
}

- (void)logout
{
    
}

@end
