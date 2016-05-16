//
//  TweetCell.m
//  Coding
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 apple. All rights reserved.
//



#define kTweetCell_PadingLeft kPaddingLeftWidth
#define kTweetCell_PadingTop (60 + 15)

#define kTweetCell_PadingBottom 10.0
#define kTweetCell_ContentWidth (kScreen_Width -kTweetCell_PadingLeft - kPaddingLeftWidth)
#define kTweetCell_LikeComment_Height 25.0
#define kTweetCell_LikeComment_Width 50.0
#define kTweetCell_LikeUserCCell_Height 25.0
#define kTweetCell_LikeUserCCell_Pading 10.0
#define kTweet_ContentFont [UIFont systemFontOfSize:16]
#define kTweet_ContentMaxHeight 120.0
#define kTweet_CommentFont [UIFont systemFontOfSize:14]
#define kTweet_TimtFont [UIFont systemFontOfSize:12]
#define kTweet_LikeUsersLineCount 7.0



#import "TweetCell.h"
#import "UICustomCollectionView.h"
#import "UIColor+UIColor_Expanded.h"
#import "UIView+Common.h"
#import "UIButton+Common.h"
#import "TweetLikeUserCCell.h"
#import "TweetMediaItemCCell.h"
#import "TweetMediaItemSingleCCell.h"
#import "TweetCommentCell.h"
#import "TweetCommentMoreCell.h"
#import "NSString+Common.h"
#import "UILabel+Common.h"
#import "NSDate+Common.h"
#import "Login.h"
#import "Coding_NetAPIManager.h"

@interface TweetCell()

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, assign) BOOL needTopView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITapImageView *ownerImgView;
@property (nonatomic, strong) UIButton *ownerNameBtn;
@property (nonatomic, strong) UITTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel, *fromLabel;
@property (nonatomic, strong) UIButton *likeBtn, *commentBtn, *deleteBtn;
@property (nonatomic, strong) UIButton *locaitonBtn;
@property (nonatomic, strong) UICustomCollectionView *mediaView;
@property (nonatomic, strong) UICollectionView *likeUsersView;
@property (nonatomic, strong) UITableView *commentListView; //评论列表
@property (nonatomic, strong) UIImageView *timeClockIconView, *commentOrLikeBeginImgView, *commentOrLikeSplitlineView;

@end

@implementation TweetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        if (!_topView) { //间隔View
            _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
            _topView.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
            [self.contentView addSubview:_topView];
        }
        
        if (!_ownerImgView) {  //头像
            self.ownerImgView = [[UITapImageView alloc] initWithFrame:CGRectMake(kPaddingLeftWidth, 15 + CGRectGetMaxY(_topView.frame), 33, 33)];
            [self.ownerImgView doCircleFrame];
            [self.contentView addSubview:self.ownerImgView];
        }
        
        if (!self.ownerNameBtn) { //名字按钮
            self.ownerNameBtn = [UIButton buttonWithUserStyle];
            self.ownerNameBtn.frame = CGRectMake(CGRectGetMaxX(self.ownerImgView.frame) + 10, 23 + CGRectGetMaxY(_topView.frame), 50, 20);
            [self.ownerNameBtn addTarget:self action:@selector(userBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.ownerNameBtn];
        }
        
        if (!self.timeClockIconView) {  //时间图片
            self.timeClockIconView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - kPaddingLeftWidth - 70, 25 + CGRectGetMaxY(_topView.frame), 12, 12)];
            self.timeClockIconView.image = [UIImage imageNamed:@"time_clock_icon"];
            [self.contentView addSubview:self.timeClockIconView];
        }
        
        
        if (!self.timeLabel) {  //时间
            self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - kPaddingLeftWidth - 55, 23 + CGRectGetMaxY(_topView.frame), 55, 12)];
            self.timeLabel.font = kTweet_TimtFont;
            self.timeLabel.textAlignment = NSTextAlignmentRight;
            self.timeLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
            [self.contentView addSubview:self.timeLabel];
        }
        
        if (!self.contentLabel) { //内容UITTTAttributedLabel
            self.contentLabel = [[UITTTAttributedLabel alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, kTweetCell_PadingTop, kTweetCell_ContentWidth, 20)];
            self.contentLabel.font = kTweet_ContentFont;
            self.contentLabel.textColor = [UIColor colorWithHexString:@"0x222222"];
            self.contentLabel.numberOfLines = 0;

            self.contentLabel.linkAttributes = kLinkAttributes;  //链接颜色
            self.contentLabel.activeLinkAttributes = kLinkAttributesActive;
            self.contentLabel.delegate = self;
            [self.contentLabel addLongPressForCopy]; //复制
            [self.contentView addSubview:self.contentLabel];

        }
        
        if (!self.commentBtn) { //评论按钮
            self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.commentBtn.frame = CGRectMake(kScreen_Width - kPaddingLeftWidth- kTweetCell_LikeComment_Width, 0, kTweetCell_LikeComment_Width, kTweetCell_LikeComment_Height);
            [self.commentBtn setImage:[UIImage imageNamed:@"tweet_comment_btn"] forState:UIControlStateNormal];
            [self.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.commentBtn];
        }
        
        if (!self.likeBtn) { //赞按钮
            self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.likeBtn.frame = CGRectMake(kScreen_Width - kPaddingLeftWidth- 2*kTweetCell_LikeComment_Width -5, 0, kTweetCell_LikeComment_Width, kTweetCell_LikeComment_Height);
            [self.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.likeBtn];
        }
        
        if (!self.deleteBtn) {  //删除按钮
            self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.deleteBtn.frame = CGRectMake(kScreen_Width - kPaddingLeftWidth- 3*kTweetCell_LikeComment_Width -5, 0, kTweetCell_LikeComment_Width, kTweetCell_LikeComment_Height);
            [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.deleteBtn setTitleColor:[UIColor colorWithHexString:@"0x3bbd79"] forState:UIControlStateNormal];
            [self.deleteBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            self.deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [self.deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.deleteBtn];
        }
        
        if (!self.locaitonBtn) { //位置
            self.locaitonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.locaitonBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.locaitonBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            self.locaitonBtn.frame = CGRectMake(kTweetCell_PadingLeft, 0, 100, 15);
            self.locaitonBtn.titleLabel.adjustsFontSizeToFitWidth = NO;
            self.locaitonBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [self.locaitonBtn setTitleColor:[UIColor colorWithHexString:@"0x3bbd79"] forState:UIControlStateNormal];
            [self.locaitonBtn addTarget:self action:@selector(locationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.locaitonBtn];
        }
        
        
        if (!self.fromLabel) { //来自   手机类型
            self.fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, 0, 100, 15)];
            self.fromLabel.font = kTweet_TimtFont;
            self.fromLabel.minimumScaleFactor = 0.50;
            self.fromLabel.adjustsFontSizeToFitWidth = YES;
            self.fromLabel.textAlignment = NSTextAlignmentLeft;
            self.fromLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
            [self.contentView addSubview:self.fromLabel];
        }
        
        if (!_commentOrLikeBeginImgView) {
            _commentOrLikeBeginImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft +20, 0, 15, 7)];

            _commentOrLikeBeginImgView.image = [UIImage imageNamed:@"commentOrLikeBeginImg"];
            [self.contentView addSubview:_commentOrLikeBeginImgView];
        }
        
        if (!self.likeUsersView) { //点过赞的人
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            self.likeUsersView = [[UICollectionView alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, 0, kTweetCell_ContentWidth, 35) collectionViewLayout:layout];
            self.likeUsersView.scrollEnabled = NO;
            [self.likeUsersView setBackgroundView:nil];
            [self.likeUsersView setBackgroundColor:kColorTableSectionBg];
            [self.likeUsersView registerClass:[TweetLikeUserCCell class] forCellWithReuseIdentifier:kCCellIdentifier_TweetLikeUser];
            self.likeUsersView.dataSource = self;
            self.likeUsersView.delegate = self;
            [self.contentView addSubview:self.likeUsersView];
        }
        
        if (!self.mediaView) { //显示的图片
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            self.mediaView = [[UICustomCollectionView alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, 0, kTweetCell_ContentWidth, 80) collectionViewLayout:layout];
            self.mediaView.scrollEnabled = NO;
            [self.mediaView setBackgroundView:nil];
            [self.mediaView setBackgroundColor:[UIColor clearColor]];
            [self.mediaView registerClass:[TweetMediaItemCCell class] forCellWithReuseIdentifier:kCCellIdentifier_TweetMediaItem];
            [self.mediaView registerClass:[TweetMediaItemSingleCCell class] forCellWithReuseIdentifier:kCCellIdentifier_TweetMediaItemSingle];
            self.mediaView.dataSource = self;
            self.mediaView.delegate = self;
            [self.contentView addSubview:self.mediaView];
        }
        
        if (!self.commentListView) {  //评论列表
            self.commentListView = [[UITableView alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, 0, kTweetCell_ContentWidth, 20) style:UITableViewStylePlain];
            self.commentListView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.commentListView.scrollEnabled = NO;
            [self.commentListView setBackgroundView:nil];
            [self.commentListView setBackgroundColor:kColorTableSectionBg];
            [self.commentListView registerClass:[TweetCommentCell class] forCellReuseIdentifier:kCellIdentifier_TweetComment];
            [self.commentListView registerClass:[TweetCommentMoreCell class] forCellReuseIdentifier:kCellIdentifier_TweetCommentMore];
            self.commentListView.dataSource = self;
            self.commentListView.delegate = self;
            [self.contentView addSubview:self.commentListView];
        }
        
        if (!_commentOrLikeSplitlineView) {
            _commentOrLikeSplitlineView = [[UIImageView alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, 0, kTweetCell_ContentWidth, 1)];
            _commentOrLikeSplitlineView.image = [UIImage imageNamed:@"splitlineImg"];
            [self.contentView addSubview:_commentOrLikeSplitlineView];
        }

    }
    return self;
}


- (void)setTweet:(Tweet *)tweet needTopView:(BOOL)needTopView {

    _tweet = tweet;
    _needTopView = needTopView;
}

- (void)awakeFromNib {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)layoutSubviews {

    [super layoutSubviews];
    if (!_tweet) {
        return;
    }
    
    //owner头像
    __weak __typeof(self)weakSelf = self;
    [self.ownerImgView setImageWithUrl:[_tweet.owner.avatar urlImageWithCodePathResizeToView:_ownerImgView] placeholderImage:kPlaceholderMonkeyRoundView(_ownerImgView) tapBlock:^(id obj) {
        [weakSelf userBtnClicked];
    }];
    
    //owner姓名
    [self.ownerNameBtn setUserTitle:_tweet.owner.name font:[UIFont systemFontOfSize:17] maxWidth:(kTweetCell_ContentWidth-85)];
    
    //发出冒泡的时间
    [self.timeLabel setLongString:[_tweet.created_at stringDisplay_HHmm] withVariableWidth:kScreen_Width/2];
    CGFloat timeLabelX = kScreen_Width - kPaddingLeftWidth - CGRectGetWidth(self.timeLabel.frame);
    [self.timeLabel setX:timeLabelX];
    [self.timeClockIconView setX:timeLabelX-15];

    
    CGFloat centerY = 15 + 15 + 33.0/2;
    CGFloat curBottomY = _needTopView? 0: -15;
    centerY += curBottomY;

    [self.topView setY:curBottomY];
    [self.ownerImgView setCenterY:centerY];
    [self.ownerNameBtn setCenterY:centerY];
    [self.timeClockIconView setCenterY:centerY];
    [self.timeLabel setCenterY:centerY];

    curBottomY += kTweetCell_PadingTop;
    
    //owner冒泡text内容
    [self.contentLabel setY:curBottomY];
    [self.contentLabel setLongString:_tweet.content withFitWidth:kTweetCell_ContentWidth maxHeight:kTweet_ContentMaxHeight];
    for (HtmlMediaItem *item in _tweet.htmlMedia.mediaItems) {
        if (item.displayStr.length > 0 && !(item.type == HtmlMediaItemType_Code || item.type == HtmlMediaItemType_EmotionEmoji)) {
            [self.contentLabel addLinkToTransitInformation:[NSDictionary dictionaryWithObject:item forKey:@"value"] withRange:item.range];
        }
    }
    
    curBottomY += [TweetCell contentLabelHeightWithTweet:_tweet];

    //图片缩略图展示
    if (_tweet.htmlMedia.imageItems.count > 0) { //collectionView  冒泡图片的缩略图
        CGFloat mediaHeight = [TweetCell contentMediaHeightWithTweet:_tweet];
        [self.mediaView setFrame:CGRectMake(kTweetCell_PadingLeft, curBottomY, kTweetCell_ContentWidth, mediaHeight)];
        [self.mediaView reloadData];
        self.mediaView.hidden = NO;
        curBottomY += mediaHeight;
    }else {
    
        if (self.mediaView) {
            self.mediaView.hidden = YES;
        }
    }
    
    BOOL isMineTweet = [_tweet.owner.global_key isEqualToString:[Login curLoginUser].global_key];
    
    //以下两段ifelse 已经判断了4种情况，经过精简得出
    //经需求修改，位置信息只会存在于设备信息上方
    
    if (_tweet.location.length > 0) {
        [self.locaitonBtn setTitle:_tweet.location forState:UIControlStateNormal];
        self.locaitonBtn.frame = CGRectMake(kTweetCell_PadingLeft, curBottomY,
                                            (kScreen_Width - kTweetCell_PadingLeft- kPaddingLeftWidth- 20), 15);
        self.locaitonBtn.hidden = NO;
        curBottomY += CGRectGetHeight(self.locaitonBtn.bounds) + 15;
    }else {
        self.locaitonBtn.hidden = YES;
    }
    
    if (_tweet.device.length > 0) {
        self.fromLabel.text = [NSString stringWithFormat:@"来自 %@",_tweet.device];
        self.fromLabel.frame = CGRectMake(kTweetCell_PadingLeft, curBottomY + 5,
                                          (isMineTweet? (kScreen_Width - kTweetCell_PadingLeft- kPaddingLeftWidth- 3*kTweetCell_LikeComment_Width- 10):
                                           (kScreen_Width - kTweetCell_PadingLeft- kPaddingLeftWidth- 2*kTweetCell_LikeComment_Width- 10)), 15);
        self.fromLabel.hidden = NO;
    }else {
    
        self.fromLabel.hidden = YES;
    }
    
    //喜欢&评论 按钮
    [self.likeBtn setImage:[UIImage imageNamed:(_tweet.liked.boolValue? @"tweet_liked_btn":@"tweet_like_btn")] forState:UIControlStateNormal];

    [self.likeBtn setY:curBottomY];
    [self.commentBtn setY:curBottomY];
    if (isMineTweet) { //自己发的冒泡，显示删除按钮
        [self.deleteBtn setY:curBottomY];
        self.deleteBtn.hidden = NO;
    }else {
        self.deleteBtn.hidden = YES;
    }
    
    curBottomY += kTweetCell_LikeComment_Height;
    curBottomY += [TweetCell likeCommentBtn_BottomPadingWithTweet:_tweet];
    
    if (_tweet.numOfLikers > 0 || _tweet.numOfComments > 0) {
        [_commentOrLikeBeginImgView setY:(curBottomY - CGRectGetHeight(_commentOrLikeBeginImgView.frame) + 1)];
        _commentOrLikeBeginImgView.hidden = NO;
    }else {
    
        _commentOrLikeBeginImgView.hidden = YES;
    }
    
    //点赞的人_列表
    //    可有可无
    if (_tweet.numOfLikers > 0) { //collectionView 点赞的人的头像
        CGFloat likeUsersHeight = [TweetCell likeUsersHeightWithTweet:_tweet];
        [self.likeUsersView setFrame:CGRectMake(kTweetCell_PadingLeft, curBottomY, kTweetCell_ContentWidth, likeUsersHeight)];
        [self.likeUsersView reloadData];
        self.likeUsersView.hidden = NO;
        curBottomY += likeUsersHeight;
    }else {
    
        if (self.likeUsersView) {
            self.likeUsersView.hidden = YES;
        }
    }
    
    //评论与赞的分割线
    if (_tweet.numOfLikers > 0 && _tweet.numOfComments > 0) {
        [_commentOrLikeSplitlineView setY:(curBottomY - 1)];
        _commentOrLikeSplitlineView.hidden = NO;
    }else {
    
        _commentOrLikeSplitlineView.hidden = YES;
    }

    //评论的人_列表
    //    可有可无
    if (_tweet.numOfComments > 0) {
        CGFloat commentListViewHeight = [TweetCell commentListViewHeightWithTweet:_tweet];
        [self.commentListView setFrame:CGRectMake(kTweetCell_PadingLeft, floor(2*curBottomY)/2.0, kTweetCell_ContentWidth, commentListViewHeight)];
        [self.commentListView reloadData];
        self.commentListView.hidden = NO;
    }else {
    
        if (self.commentListView) {
            self.commentListView.hidden = YES;
        }
    }

}

+ (CGFloat)cellHeightWithObj:(id)obj needTopView:(BOOL)needTopView {

    Tweet *tweet = (Tweet *)obj;
    CGFloat cellHeight = 0;
    cellHeight += needTopView? 0 : -15;
    cellHeight +=  kTweetCell_PadingTop;
    cellHeight += [self contentLabelHeightWithTweet:tweet];
    cellHeight += [self contentMediaHeightWithTweet:tweet];
    cellHeight += [self locationHeightWithTweet:tweet];
    cellHeight += kTweetCell_LikeComment_Height;
    cellHeight += [TweetCell likeCommentBtn_BottomPadingWithTweet:tweet];
    cellHeight += [TweetCell likeUsersHeightWithTweet:tweet];
    cellHeight += [TweetCell commentListViewHeightWithTweet:tweet];
    cellHeight += 15;
    return ceilf(cellHeight); //向上取整函数
}


+ (CGFloat)contentLabelHeightWithTweet:(Tweet *)tweet {

    CGFloat height = 0;
    if (tweet.content.length > 0) {
        height += MIN(kTweet_ContentMaxHeight, [tweet.content getHeightWithFont:kTweet_ContentFont constrainedToSize:CGSizeMake(kTweetCell_ContentWidth, CGFLOAT_MAX)]);
        height += 15;
    }
    
    return height;
}

+ (CGFloat)contentMediaHeightWithTweet:(Tweet *)tweet {

    CGFloat contentMediaHeight = 0;
    NSInteger mediaCount = tweet.htmlMedia.imageItems.count;
    if (mediaCount > 0) {
        HtmlMediaItem *curMediaItem = tweet.htmlMedia.imageItems.firstObject;
        contentMediaHeight = (mediaCount == 1)? [TweetMediaItemSingleCCell ccellSizeWithObj:curMediaItem].height :         ceilf((float)mediaCount/3)*([TweetMediaItemCCell ccellSizeWithObj:curMediaItem].height+3.0) - 3.0;
        contentMediaHeight += 15;//padding
    }
    return contentMediaHeight;
}

+ (CGFloat)locationHeightWithTweet:(Tweet *)tweet {

    CGFloat locationHeight = 0;
    if (tweet.location.length > 0) {
        locationHeight = 15 + 15;
    }else {
    
        locationHeight = 0;
    }
    return locationHeight;
}

+ (CGFloat)likeCommentBtn_BottomPadingWithTweet:(Tweet *)tweet {
    if (tweet && (tweet.likes.intValue > 0 || tweet.comments.intValue > 0)) {
        return 15.f;
    }else {
        return 0;
    }
}

+ (CGFloat)likeUsersHeightWithTweet:(Tweet *)tweet {
    CGFloat likeUsersHeight = 0;
    if (tweet.likes.intValue > 0) {
        likeUsersHeight = 45;
    }
    return likeUsersHeight;
}

+ (CGFloat)commentListViewHeightWithTweet:(Tweet *)tweet {

    if (!tweet) {
        return 0;
    }
    CGFloat commentListViewHeight = 0;
    NSInteger numOfComments = tweet.numOfComments;
    BOOL hasMoreComments = tweet.hasMoreComments;
    for (int i = 0; i < numOfComments; i++) {
        if (i == numOfComments - 1 && hasMoreComments) {
            commentListViewHeight += [TweetCommentMoreCell cellHeight];
        }else {
        
            Comment *curComment = [tweet.comment_list objectAtIndex:i];
            commentListViewHeight += [TweetCommentCell cellHeightWithObj:curComment];
        }
    }
    
    return commentListViewHeight;
}

#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger row = 0;
    if (collectionView == _mediaView) { //缩略图
        row = _tweet.htmlMedia.imageItems.count;
    }else { //点赞头像
        row = _tweet.numOfLikers;
    }
    
    return row;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (collectionView == _mediaView) { //缩略图
        HtmlMediaItem *curMediaItem = [_tweet.htmlMedia.imageItems objectAtIndex:indexPath.row];
        if (_tweet.htmlMedia.imageItems.count == 1) {
            TweetMediaItemSingleCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_TweetMediaItemSingle forIndexPath:indexPath];
            ccell.curMediaItem = curMediaItem;
            ccell.refreshSingleCCellBlock = ^(){
                if (_refreshSingleCCellBlock) {
                    _refreshSingleCCellBlock();
                }
            };
            return ccell;
        }else {
        
            TweetMediaItemCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_TweetMediaItem forIndexPath:indexPath];
            ccell.curMediaItem = curMediaItem;
            return ccell;
        }
    }else {//点赞头像
        TweetLikeUserCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_TweetLikeUser forIndexPath:indexPath];
        if (indexPath.row >= _tweet.numOfLikers - 1 && _tweet.hasMoreLikers) {
            [ccell configWithUser:nil likesNum:_tweet.likes];
        }else {
        
            User *curUser = [_tweet.like_users objectAtIndex:indexPath.row];
            [ccell configWithUser:curUser likesNum:nil];
        }
        return ccell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize itemSize;
    if (collectionView == _mediaView) { //缩略图
        if (_tweet.htmlMedia.imageItems.count == 1) {
            itemSize = [TweetMediaItemSingleCCell ccellSizeWithObj:_tweet.htmlMedia.imageItems.firstObject];
        }else {
            itemSize = [TweetMediaItemCCell ccellSizeWithObj:_tweet.htmlMedia.imageItems.firstObject];
        }
    }else { //点赞头像
        itemSize = CGSizeMake(kTweetCell_LikeUserCCell_Height, kTweetCell_LikeUserCCell_Height);

    }
    return itemSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    UIEdgeInsets insetForSection;
    if (collectionView == _mediaView) { //缩略图
        if (_tweet.htmlMedia.imageItems.count == 1) {
            CGSize itemSize = [TweetMediaItemSingleCCell ccellSizeWithObj:_tweet.htmlMedia.imageItems.firstObject];
            insetForSection = UIEdgeInsetsMake(0, 0, 0, kTweetCell_ContentWidth - itemSize.width);
        }else {
            insetForSection = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }else { //点赞头像
        insetForSection = UIEdgeInsetsMake(kTweetCell_LikeUserCCell_Pading, 5, kTweetCell_LikeUserCCell_Pading, 5);
    }
    
    return insetForSection;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    if (collectionView == _mediaView) {
        return 3.f;
    }else {
        return kTweetCell_LikeUserCCell_Pading;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == _mediaView) {
        return 3.f;
    }else {
        return kTweetCell_LikeUserCCell_Pading/2;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (collectionView == _mediaView) { //缩略图
        //        显示大图

        
        // 2.显示相册

    }else {//点赞头像
        if (indexPath.row >= _tweet.numOfLikers - 1 && _tweet.hasMoreLikers) {
            if (_moreLikersBtnClickedBlock) {
                _moreLikersBtnClickedBlock(_tweet);
            }
        }else {
        
            User *curUser = [_tweet.like_users objectAtIndex:indexPath.row];
            if (_userBtnClickedBlock) {
                _userBtnClickedBlock(curUser);
            }
        }
    }
}

#pragma mark Table M comments
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _tweet.numOfComments;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row >= _tweet.numOfComments - 1 && _tweet.hasMoreLikers) {
        TweetCommentMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TweetCommentMore forIndexPath:indexPath];
        cell.commentNum = _tweet.comments;
        return cell;
    }else {
    
        TweetCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TweetComment forIndexPath:indexPath];
        Comment *curComment = [_tweet.comment_list objectAtIndex:indexPath.row];
        [cell configWithComment:curComment topLine:(indexPath.row != 0)];
        cell.commentLabel.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat cellHeight = 0;
    if (indexPath.row >= _tweet.numOfComments - 1 && _tweet.hasMoreLikers) {
        cellHeight = [TweetCommentMoreCell cellHeight];
    }else {
        Comment *curComment = [_tweet.comment_list objectAtIndex:indexPath.row];
        cellHeight = [TweetCommentCell cellHeightWithObj:curComment];
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= _tweet.numOfComments - 1 && _tweet.hasMoreLikers) {
        DebugLog(@"More Comment");
        if (_goToDetailTweetBlock) {
            _goToDetailTweetBlock(_tweet);
        }
    }else {
    
        if (_commentClickedBlock) {
            _commentClickedBlock(_tweet,indexPath.row,[tableView cellForRowAtIndexPath:indexPath]);
        }
    }
}

#pragma mark Table Copy
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row >= _tweet.numOfComments - 1 && _tweet.hasMoreLikers) {
        return NO;
    }
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {

    if (action == @selector(copy:)) {
        Comment *curComment = [_tweet.comment_list objectAtIndex:indexPath.row];

        [UIPasteboard generalPasteboard].string = curComment.content? curComment.content : @"";
    }
}

#pragma mark Btn M
- (void)userBtnClicked {
    if (_userBtnClickedBlock) {
        _userBtnClickedBlock(_tweet.owner);
    }
}

- (void)commentBtnClicked:(id)sender {
    if (_commentClickedBlock) {
        _commentClickedBlock(_tweet,-1,sender);
    }
}

- (void)deleteBtnClicked:(UIButton *)sender {

    if (_deleteClickedBlock) {
        _deleteClickedBlock(_tweet,_outTweetsIndex);
    }
}

- (void)locationBtnClicked:(id)sender {

    if (_locationClickedBlock) {
        _locationClickedBlock(_tweet);
    }
}

- (void)likeBtnClicked:(id)sender {

    [[Coding_NetAPIManager sharedManager] request_Tweet_DoLike_WithObj:_tweet andBlock:^(id data, NSError *error) {
        if (data) {
            [_tweet changeToLiked:[NSNumber numberWithBool:!_tweet.liked.boolValue]];
            [self.likeBtn setImage:[UIImage imageNamed:(_tweet.liked.boolValue? @"tweet_liked_btn":@"tweet_like_btn")] forState:UIControlStateNormal];
            if (_likeBtnClickedBlock) {
                _likeBtnClickedBlock(_tweet);
            }
        }
    }];
}

#pragma mark TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    if (_mediaItemClickedBlock) {
        _mediaItemClickedBlock([components objectForKey:@"value"]);
    }
}

@end
