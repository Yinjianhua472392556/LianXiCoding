//
//  UILabel+Common.h
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)

- (void) setLongString:(NSString *)str withFitWidth:(CGFloat)width;
- (void) setLongString:(NSString *)str withFitWidth:(CGFloat)width maxHeight:(CGFloat)maxHeight;
- (void) setLongString:(NSString *)str withVariableWidth:(CGFloat)maxWidth;
+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor;

@end
