//
//  YYHTTPManager.h
//  YouYun
//
//  Created by Ranchao Zhang on 3/15/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "YYUser.h"

static NSString *API_CALL_FAILED_NOTIFICATION = @"API_CALL_FAILED_NOTIFICATION";

@class YYUser;

@interface YYHTTPManager : NSObject

@property (nonatomic, retain) NSString *serverProtocol;
@property (nonatomic, retain) NSString *serverHost;
@property (nonatomic, retain) NSString *serverPort;

+ (YYHTTPManager *) I;
- (void)GET:(NSString *) path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
- (void)POST:(NSString *) path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

@end
