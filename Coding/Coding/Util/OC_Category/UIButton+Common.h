//
//  UIButton+Common.h
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UIButton (Common)
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color;
+ (UIButton *)buttonWithTitle_ForNav:(NSString *)title;
+ (UIButton *)buttonWithUserStyle;
- (void)userNameStyle;
- (void)frameToFitTitle;
- (void)setUserTitle:(NSString *)aUserName;
- (void)setUserTitle:(NSString *)aUserName font:(UIFont *)font maxWidth:(CGFloat)maxWidth;

- (void)configFollowBtnWithUser:(User *)curUser fromCell:(BOOL)fromCell;
+ (UIButton *)btnFollowWithUser:(User *)curUser;

- (void)configPriMsgBtnWithUser:(User *)curUser fromCell:(BOOL)fromCell;
+ (UIButton *)btnPriMsgWithUser:(User *)curUser;

@end
