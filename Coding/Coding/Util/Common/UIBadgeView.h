//
//  UIBadgeView.h
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * Text that is displayed in the upper-right corner of the item with a surrounding background.
 */

@interface UIBadgeView : UIView
@property (nonatomic, copy) NSString *badgeValue;

+ (UIBadgeView *)viewWithBadgeTip:(NSString *)badgeValue;
+ (CGSize)badgeSizeWithStr:(NSString *)badgeValue font:(UIFont *)font;
- (CGSize)badgeSizeWithStr:(NSString *)badgeValue;

@end
