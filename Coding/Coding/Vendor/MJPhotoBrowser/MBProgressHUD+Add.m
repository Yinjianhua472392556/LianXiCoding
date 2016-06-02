//
//  MBProgressHUD+Add.m
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {

    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.7];
    
}
#pragma mark 显示错误信息

+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {

    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    return hud;
}

@end
