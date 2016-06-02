//
//  MBProgressHUD+Add.h
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

@end
