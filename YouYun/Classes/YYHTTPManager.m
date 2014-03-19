//
//  YYHTTPManager.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/15/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYHTTPManager.h"

@implementation YYHTTPManager

static YYHTTPManager *manager;

+ (YYHTTPManager *) I
{
    if (manager == nil) {
		static dispatch_once_t pred;
		dispatch_once(&pred, ^{
            manager = [[YYHTTPManager alloc] init];
        });
	}
	return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
        if (settings[@"school server"]) {
            settings = settings[@"school server"];
            if (settings) {
                _serverProtocol = settings[@"protocol"] ? settings[@"protocol"] : @"http";
                _serverHost = settings[@"host"] ? settings[@"host"] : nil;
                _serverPort = settings[@"port"] ? settings[@"port"] : nil;
                NSAssert(_serverHost != nil && _serverProtocol != nil, @"Must define server hostname and protocol.");
            }
        }
    }
    return self;
}

- (void)GET:(NSString *) path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [[AFHTTPRequestOperationManager manager] GET:[self constructUrlFromPath:path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)POST:(NSString *) path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [[AFHTTPRequestOperationManager manager] POST:[self constructUrlFromPath:path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (NSString *)constructUrlFromPath:(NSString *) path
{
    NSMutableString *ret = [NSMutableString new];
    [ret appendFormat:@"%@://%@", _serverProtocol, _serverHost];
    if (_serverPort) [ret appendFormat:@":%@", _serverPort];
    [ret appendString:path];
    return ret;
}

@end
