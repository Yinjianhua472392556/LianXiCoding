//
//  TweetMediaItemSingleCCell.m
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kTweetMediaItemCCellSingle_Width (0.6 *kScreen_Width)
#define kTweetMediaItemCCellSingle_WidthMonkey ((kScreen_Width - 36.0)/3.0)
#define kTweetMediaItemCCellSingle_MaxHeight (0.5 *kScreen_Height)


#import "TweetMediaItemSingleCCell.h"

@implementation TweetMediaItemSingleCCell
@synthesize curMediaItem = _curMediaItem, imgView = _imgView, gifMarkView = _gifMarkView;

//- (void)setCurMediaItem:(HtmlMediaItem *)curMediaItem {
//    if (!_imgView) {
//        _imgView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, kTweetMediaItemCCellSingle_Width, kTweetMediaItemCCellSingle_Width)];
//        _imgView.contentMode = UIViewContentModeScaleAspectFill;
//        _imgView.clipsToBounds = YES;
//        //        _imgView.layer.masksToBounds = YES;
//        //        _imgView.layer.cornerRadius = 2.0;
//        [self.contentView addSubview:_imgView];
//    }
//    if (_curMediaItem != curMediaItem) {
//        _curMediaItem = curMediaItem;
//    }
//    __weak typeof(self) weakSelf = self;
//    CGSize reSize;
//
//    if (curMediaItem.type == HtmlMediaItemType_EmotionMonkey) {
//        reSize = CGSizeMake(kTweetMediaItemCCellSingle_WidthMonkey, kTweetMediaItemCCellSingle_WidthMonkey);
//
//    }else {
////        reSize = [[ImageSizeManager shareManager] sizeWithSrc:_curMediaItem.src originalWidth:kTweetMediaItemCCellSingle_Width maxHeight:kTweetMediaItemCCellSingle_MaxHeight];
//    }
//}

@end
