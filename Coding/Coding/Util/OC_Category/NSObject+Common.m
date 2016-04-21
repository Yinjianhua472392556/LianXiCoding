//
//  NSObject+Common.m
//  Coding
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSObject+Common.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "User.h"
#import "Login.h"
#import "NSString+Common.h"
#import "AppDelegate.h"

#define kTestKey @"BaseURLIsTest"
#define kPath_ResponseCache @"ResponseCache"


@implementation NSObject (Common)
+ (BOOL)baseURLStrIsTest{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults valueForKey:kTestKey] boolValue];
}

#pragma mark BaseURL
+ (NSString *)baseURLStr{
    NSString *baseURLStr;
    if ([self baseURLStrIsTest]) {
        //staging
        baseURLStr = kBaseUrlStr_Test;
    }else{
        //生产
        baseURLStr = @"https://coding.net/";
    }
    
    //    {//其他
    //        //村民
    //        baseURLStr = @"http://192.168.0.188:8080/";
    //
    //        //彭博
    //        baseURLStr = @"http://192.168.0.156:9990/";
    //    }
    
    return baseURLStr;
}


- (BOOL)showError:(NSError *)error{
    NSString *tipStr = [self tipFromError:error];
    [self showHudTipStr:tipStr];
    return YES;
}


- (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabelText = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
    }
}


#pragma mark Tip M
- (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"msg"]) {
            NSArray *msgArray = [[error.userInfo objectForKey:@"msg"] allValues];
            NSUInteger num = [msgArray count];
            for (int i = 0; i < num; i++) {
                NSString *msgStr = [msgArray objectAtIndex:i];
                if (i+1 < num) {
                    [tipStr appendString:[NSString stringWithFormat:@"%@\n", msgStr]];
                }else{
                    [tipStr appendString:msgStr];
                }
            }
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}



+ (id) loadResponseWithPath:(NSString *)requestPath{//返回一个NSDictionary类型的json数据
    User *loginUser = [Login curLoginUser];
    if (!loginUser) {
        return nil;
    }else{
        requestPath = [NSString stringWithFormat:@"%@_%@", loginUser.global_key, requestPath];
    }
    NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath md5Str]];
    return [NSMutableDictionary dictionaryWithContentsOfFile:abslutePath];
}


#pragma mark File M
//获取fileName的完整地址
+ (NSString* )pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}


-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError{
    NSError *error = nil;
    //code为非0值时，表示有错
    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];
    
    if (resultCode.intValue != 0) {
        error = [NSError errorWithDomain:[NSObject baseURLStr] code:resultCode.intValue userInfo:responseJSON];
        
        if (resultCode.intValue == 1000 || resultCode.intValue == 3207) {//用户未登录
            if ([Login isLogin]) {//已登录的状态要抹掉
                [Login doLogout];
                [((AppDelegate *)[UIApplication sharedApplication].delegate) setupLoginViewController];
                kTipAlert(@"%@", [self tipFromError:error]);
            }
        }else{
            if (autoShowError) {
                [self showError:error];
            }
        }
    }
    return error;
}

//网络请求
+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath{
    User *loginUser = [Login curLoginUser];
    if (!loginUser) {
        return NO;
    }else{
        requestPath = [NSString stringWithFormat:@"%@_%@", loginUser.global_key, requestPath];
    }
    if ([self createDirInCache:kPath_ResponseCache]) {
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath md5Str]];
        return [data writeToFile:abslutePath atomically:YES];
    }else{
        return NO;
    }
}


//创建缓存文件夹
+ (BOOL) createDirInCache:(NSString *)dirName
{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}



@end
