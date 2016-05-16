//
//  UITTTAttributedLabel.h
//  Coding
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TTTAttributedLabel.h"

typedef void(^UITTTLabelTapBlock)(id aObj);

@interface UITTTAttributedLabel : TTTAttributedLabel
- (void)addLongPressForCopy;
- (void)addLongPressForCopyWithBGColor:(UIColor *)color;
- (void)addTapBlock:(UITTTLabelTapBlock)block;
- (void)addDeleteBlock:(UITTTLabelTapBlock)block;
@end
