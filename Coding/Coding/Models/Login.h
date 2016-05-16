//
//  Login.h
//  Coding
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Login : NSObject
//请求
@property (readwrite, nonatomic, strong) NSString *email, *password, *j_captcha;
@property (readwrite, nonatomic, strong) NSNumber *remember_me;


+ (BOOL) isLogin;
+ (void) doLogin:(NSDictionary *)loginData;
+ (void) doLogout;
+ (NSString *)preUserEmail;
+ (User *)userWithGlobaykeyOrEmail:(NSString *)textStr;
+ (void)setPreUserEmail:(NSString *)emailStr;
+ (NSMutableDictionary *)readLoginDataList;

+ (User *)curLoginUser;

- (NSDictionary *)toParams;

+ (BOOL)isLoginUserGlobalKey:(NSString *)global_key;
@end
