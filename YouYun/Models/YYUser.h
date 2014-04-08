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

typedef NS_ENUM(NSInteger, YYUserType) {
    YYUserTypeAdmin,
    YYUserTypeTeacher,
    YYUserTypeStudent,
    YYUserTypeParent
};

@interface YYUser : NSObject

+ (YYUser *)I;
- (NSString *) typeKey;
- (void)isUserLoggedIn:(void (^) (BOOL userLoggedIn, NSInteger statusCode)) callback;
- (void)loginWithUsername:(NSString *) username andPassword:(NSString *) password;
- (void)logout;

@end
