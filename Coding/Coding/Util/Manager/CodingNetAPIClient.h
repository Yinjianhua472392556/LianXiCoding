//
//  CodingNetAPIClient.h
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


typedef NS_ENUM(NSUInteger, NetworkMethod) {
    Get = 0,
    Post,
    Put,
    Delete
};

@interface CodingNetAPIClient : AFHTTPRequestOperationManager

+ (id)sharedJsonClient;


- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block;

@end
