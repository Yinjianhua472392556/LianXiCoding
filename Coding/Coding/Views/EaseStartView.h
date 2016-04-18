//
//  EaseStartView.h
//  Coding
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EaseStartView : UIView
+ (instancetype)startView;

- (void)startAnimationWithCompletionBlock:(void (^)(EaseStartView *easeStartView))completionHandler;

@end
