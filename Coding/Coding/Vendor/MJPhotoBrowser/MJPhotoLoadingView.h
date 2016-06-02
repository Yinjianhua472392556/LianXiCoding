//
//  MJPhotoLoadingView.h
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinProgress 0.0001

@interface MJPhotoLoadingView : UIView
@property (nonatomic, assign) float progress;

- (void)showLoading;
- (void)showFailure;
@end
