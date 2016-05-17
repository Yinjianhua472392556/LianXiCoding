//
//  UICustomCollectionView.m
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UICustomCollectionView.h"

@implementation UICustomCollectionView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    UIView *__tmpView = [super hitTest:point withEvent:event];
    if (__tmpView == self) {
        return nil;
    }
    
    return __tmpView;
}

@end
