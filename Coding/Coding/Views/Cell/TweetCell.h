//
//  TweetCell.h
//  Coding
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kCellIdentifier_Tweet @"TweetCell"


#import <UIKit/UIKit.h>
#import "Tweets.h"
#import "UITapImageView.h"
#import "UITTTAttributedLabel.h"
#import "HtmlMedia.h"


typedef void(^CommentClickedBlock)(Tweet *curTweet, NSInteger index, id sender);
typedef void(^DeleteClickedBlock)(Tweet *curTweet, NSInteger outTweetsIndex);
typedef void(^LikeBtnClickedBlock)(Tweet *curTweet);
typedef void(^UserBtnClickedBlock)(User *curUser);
typedef void(^MoreLikersBtnClickedBlock)(Tweet *curTweet);
typedef void(^LocationClickedBlock)(Tweet *curTweet);


@interface TweetCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate>
@property (nonatomic, assign) NSInteger outTweetsIndex;

- (void)setTweet:(Tweet *)tweet needTopView:(BOOL)needTopView;

@property (nonatomic, copy) CommentClickedBlock commentClickedBlock;
@property (nonatomic, copy) LikeBtnClickedBlock likeBtnClickedBlock;
@property (nonatomic, copy) UserBtnClickedBlock userBtnClickedBlock;
@property (nonatomic, copy) MoreLikersBtnClickedBlock moreLikersBtnClickedBlock;
@property (nonatomic, copy) DeleteClickedBlock deleteClickedBlock;
@property (nonatomic, copy) LocationClickedBlock locationClickedBlock;
@property (nonatomic, copy) void (^goToDetailTweetBlock)(Tweet *curTweet);
@property (nonatomic, copy) void (^refreshSingleCCellBlock)();
@property (nonatomic, copy) void (^mediaItemClickedBlock)(HtmlMediaItem *curItem);

+ (CGFloat)cellHeightWithObj:(id)obj needTopView:(BOOL)needTopView; //TopView为每个cell之间的间距  cell的高度

@end
