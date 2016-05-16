//
//  TweetMediaItemCCell.h
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kCCellIdentifier_TweetMediaItem @"TweetMediaItemCCell"


#import <UIKit/UIKit.h>
#import "HtmlMedia.h"
#import "YLImageView.h"

@interface TweetMediaItemCCell : UICollectionViewCell

@property (nonatomic, strong) HtmlMediaItem *curMediaItem;
@property (nonatomic, strong) YLImageView *imgView;
@property (nonatomic, strong) UIImageView *gifMarkView;
+ (CGSize)ccellSizeWithObj:(id)obj;

@end
