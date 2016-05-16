//
//  CodingBannersView.h
//  Coding
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodingBanner.h"

@interface CodingBannersView : UIView
@property (nonatomic, strong) NSArray *curBannerList;
@property (nonatomic, copy) void (^tapActionBlock)(CodingBanner *tapedBanner);
- (void)reloadData;
@end
