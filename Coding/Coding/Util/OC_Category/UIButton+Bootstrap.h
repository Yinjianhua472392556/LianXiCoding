//
//  UIButton+Bootstrap.h
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSString+FontAwesome.h>

typedef enum {
    StrapBootstrapStyle = 0,
    StrapDefaultStyle,
    StrapPrimaryStyle,
    StrapSuccessStyle,
    StrapInfoStyle,
    StrapWarningStyle,
    StrapDangerStyle
} StrapButtonStyle;


@interface UIButton (Bootstrap)

- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before;
-(void)bootstrapStyle;
-(void)defaultStyle;
-(void)primaryStyle;
-(void)successStyle;
-(void)infoStyle;
-(void)warningStyle;
-(void)dangerStyle;
- (UIImage *) buttonImageFromColor:(UIColor *)color ;
+ (UIButton *)buttonWithStyle:(StrapButtonStyle)style andTitle:(NSString *)title andFrame:(CGRect)rect target:(id)target action:(SEL)selector;


@end
