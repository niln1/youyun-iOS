//
//  YYUser.h
//  YouYun
//
//  Created by Ranchao Zhang on 3/10/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YYUserType) {
    YYUserTypeAdmin,
    YYUserTypeTeacher,
    YYUserTypeStudent,
    YYUserTypeParent
};

@interface YYUser : NSObject

+ (YYUser *)I;
- (BOOL)isLoggedIn;
- (void)loginWithUsername:(NSString *) username andPassword:(NSString *) password;
- (void)logout;

@end
