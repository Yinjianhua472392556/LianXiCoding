//
//  CodingNetAPIClient.m
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CodingNetAPIClient.h"


#define kNetworkMethodName @[@"Get", @"Post", @"Put", @"Delete"]

static CodingNetAPIClient *_sharedClient = nil;

@implementation CodingNetAPIClient


+ (id)sharedJsonClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CodingNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[NSObject baseURLStr]]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {

    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
    self.securityPolicy.allowInvalidCertificates = YES;
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath withParams:(NSDictionary *)params withMethodType:(NetworkMethod)method andBlock:(void (^)(id, NSError *))block {

    [self requestJsonDataWithPath:aPath withParams:params withMethodType:method autoShowError:YES andBlock:block];
}

- (void)requestJsonDataWithPath:(NSString *)aPath withParams:(NSDictionary *)params withMethodType:(NetworkMethod)method autoShowError:(BOOL)autoShowError andBlock:(void (^)(id, NSError *))block {
    if (!aPath || aPath.length <= 0) {
        return;
    }
    
    //log请求数据
    DebugLog(@"\n===========request===========:%@\n%@:\n%@", kNetworkMethodName[method], aPath, params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //发起请求

    [self.securityPolicy setAllowInvalidCertificates:NO];

    switch (method) {
        case Get:{
            //所有 Get 请求，增加缓存机制
            NSMutableString *localPath = [aPath mutableCopy];
            if (params) {
                [localPath appendString:params.description];
            }
            
            [self GET:aPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    responseObject = [NSObject loadResponseWithPath:localPath];
                    block(responseObject,error);
                }else {
                
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        [NSObject saveResponseData:responseObject toPath:localPath];
                    }
                    block(responseObject,nil);
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                !autoShowError || [self showError:error];
                id responseObject = [NSObject loadResponseWithPath:localPath];
                block(responseObject, error);
            }];

            break;
        }
        case Post: {
        [self POST:aPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
            id error = [self handleResponse:responseObject autoShowError:autoShowError];
            if (error) {
                block(nil,error);
            }else {
                block(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
            !autoShowError || [self showError:error];
            block(nil, error);

        }];
            break;
        }
            
        case Put: {
        [self PUT:aPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
            id error = [self handleResponse:responseObject autoShowError:autoShowError];

            if (error) {
                block(nil,error);
            }else {
                block(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
            !autoShowError || [self showError:error];
            block(nil, error);
        }];
            break;
        }
            
        case Delete: {
        
            [self DELETE:aPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil,error);
                }else {
                    block(responseObject,nil);
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                !autoShowError || [self showError:error];
                block(nil, error);
            }];
            break;
        }
        default:
            break;
    }
    
    
}

@end
