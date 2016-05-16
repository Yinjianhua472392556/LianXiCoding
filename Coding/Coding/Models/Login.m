//
//  Login.m
//  Coding
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Login.h"
#import "NSObject+ObjectMap.h"
#import "NSString+Common.h"
#define kLoginDataListPath @"login_data_list_path.plist"


#define kLoginStatus @"login_status"
#define kLoginUserDict @"user_dict"
#define kLoginPreUserEmail @"pre_user_email"

static User *_curLoginUser;

@implementation Login

+ (BOOL)isLogin {

    NSNumber *loginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginStatus];
    if (loginStatus.boolValue && [Login curLoginUser]) {
        User *loginUser = [Login curLoginUser];
        if (loginUser.status && loginUser.status.integerValue == 0) {
            return NO;
        }
        
        return YES;
    }else {
    
        return NO;
    }
}

+ (User *)curLoginUser {
    if (!_curLoginUser) {
        NSDictionary *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict];
        _curLoginUser = loginData? [NSObject objectOfClass:@"User" fromJSON:loginData] : nil;
        
    }
    return _curLoginUser;
}

+ (NSString *)preUserEmail {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kLoginPreUserEmail];
}


+ (NSMutableDictionary *)readLoginDataList{
    NSMutableDictionary *loginDataList = [NSMutableDictionary dictionaryWithContentsOfFile:[self loginDataListPath]];
    if (!loginDataList) {
        loginDataList = [NSMutableDictionary dictionary];
    }
    return loginDataList;
}


+ (NSString *)loginDataListPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:kLoginDataListPath];
}


+ (User *)userWithGlobaykeyOrEmail:(NSString *)textStr{
    NSMutableDictionary *loginDataList = [self readLoginDataList];
    NSDictionary *loginData = [loginDataList objectForKey:textStr];
    if (loginData) {
        return [NSObject objectOfClass:@"User" fromJSON:loginData];
    }
    return nil;
}


- (NSDictionary *)toParams{
    if (self.j_captcha && self.j_captcha.length > 0) {
        return @{@"email" : self.email,
                 @"password" : [self.password sha1Str],
                 @"remember_me" : self.remember_me? @"true" : @"false",
                 @"j_captcha" : self.j_captcha};
    }else{
        return @{@"email" : self.email,
                 @"password" : [self.password sha1Str],
                 @"remember_me" : self.remember_me? @"true" : @"false"};
    }
}


+ (void)doLogin:(NSDictionary *)loginData{
    if (loginData) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:kLoginStatus];
        [defaults setObject:loginData forKey:kLoginUserDict];
        _curLoginUser = [NSObject objectOfClass:@"User" fromJSON:loginData];
        [defaults synchronize];
//        [Login setXGAccountWithCurUser];
        
        [self saveLoginData:loginData];
    }else{
        [Login doLogout];
    }
}


+ (BOOL)saveLoginData:(NSDictionary *)loginData{
    BOOL saved = NO;
    if (loginData) {
        NSMutableDictionary *loginDataList = [self readLoginDataList];
        User *curUser = [NSObject objectOfClass:@"User" fromJSON:loginData];
        if (curUser.global_key) {
            [loginDataList setObject:loginData forKey:curUser.global_key];
            saved = YES;
        }
        if (curUser.email) {
            [loginDataList setObject:loginData forKey:curUser.email];
            saved = YES;
        }
        if (saved) {
            saved = [loginDataList writeToFile:[self loginDataListPath] atomically:YES];
        }
    }
    return saved;
}


+ (void)doLogout{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:kLoginStatus];
    [defaults synchronize];
//    [Login setXGAccountWithCurUser];
}


+ (void)setPreUserEmail:(NSString *)emailStr{
    if (emailStr.length <= 0) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:emailStr forKey:kLoginPreUserEmail];
    [defaults synchronize];
}


+ (BOOL)isLoginUserGlobalKey:(NSString *)global_key {

    if (global_key.length <= 0) {
        return NO;
    }
    
    return [[self curLoginUser].global_key isEqualToString:global_key];
}

@end
