//
//  YYHTTPManager.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/15/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYHTTPManager.h"

static NSString * const SESSION_KEY = @"SESSION_KEY";

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

- (void)saveCookies
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey:SESSION_KEY];
    [defaults synchronize];
    
}

- (void)loadCookies
{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:SESSION_KEY]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    
}

- (AFHTTPRequestOperation *)GET:(NSString *) path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self loadCookies];
    
    OLog(path);
    return [[AFHTTPRequestOperationManager manager] GET:[self constructUrlFromPath:path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        OLog(responseObject);
        [self saveCookies];
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        OLog(error);
        [self saveCookies];
        NSHTTPURLResponse *response = operation.response;
        NSString *notificationName = response.statusCode == 401 ? USER_SESSION_INVALID_NOTIFICATION : API_CALL_FAILED_NOTIFICATION;
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        failure(operation, error);
    }];
}

- (AFHTTPRequestOperation *)POST:(NSString *) path formWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    return [self POST:path helperWithParameters:parameters success:success failure:failure isJSON:NO];
}

- (AFHTTPRequestOperation *)POST:(NSString *) path jsonWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    return [self POST:path helperWithParameters:parameters success:success failure:failure isJSON:YES];
}

- (AFHTTPRequestOperation *)POST:(NSString *)path helperWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure isJSON:(BOOL) isJSON
{
    [self loadCookies];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    if (isJSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    } else {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    OLog(path);
    return [manager POST:[self constructUrlFromPath:path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        OLog(responseObject);
        [self saveCookies];
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        OLog(error);
        [self saveCookies];
        NSHTTPURLResponse *response = operation.response;
        NSString *notificationName = response.statusCode == 401 ? USER_SESSION_INVALID_NOTIFICATION : API_CALL_FAILED_NOTIFICATION;
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
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
