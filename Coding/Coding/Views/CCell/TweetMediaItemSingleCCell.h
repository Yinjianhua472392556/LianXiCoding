//
//  TweetMediaItemSingleCCell.h
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kCCellIdentifier_TweetMediaItemSingle @"TweetMediaItemSingleCCell"


#import "TweetMediaItemCCell.h"

@interface TweetMediaItemSingleCCell : TweetMediaItemCCell
@property (nonatomic, copy) void (^refreshSingleCCellBlock)();
+ (CGSize)ccellSizeWithObj:(id)obj;
@end
