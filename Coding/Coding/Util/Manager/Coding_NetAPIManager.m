//
//  Coding_NetAPIManager.m
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Coding_NetAPIManager.h"
#import "CodingNetAPIClient.h"
#import "User.h"
#import "Login.h"
#import "NSObject+ObjectMap.h"

@implementation Coding_NetAPIManager

+ (instancetype)sharedManager {

    static Coding_NetAPIManager *shared_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_manager = [[self alloc] init];
    });
    
    return shared_manager;
}


- (void)request_CaptchaNeededWithPath:(NSString *)path andBlock:(void (^)(id, NSError *))block {

    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            id resultData = [data valueForKeyPath:@"data"];
            block(resultData,nil);
        }else {
            block(nil,error);
        }
    }];
}


- (void)request_Login_WithParams:(id)params andBlock:(void (^)(id, NSError *))block {

    NSString *path = @"api/login";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        id resultData = [data valueForKeyPath:@"data"];
        if (resultData) {
            User *curLoginUser = [NSObject objectOfClass:@"User" fromJSON:resultData];
            if (curLoginUser) {
                [Login doLogin:resultData];
            }
            block(curLoginUser,nil);
        }else {
        
            block(nil,error);
        }
    }];
}



- (void)loadImageWithPath:(NSString *)imageUrlStr completeBlock:(void (^)(UIImage *, NSError *))block {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrlStr]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        block(nil,error);
    }];
    
    [requestOperation start];
}

@end
