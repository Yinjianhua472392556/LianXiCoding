//
//  TweetLikeUserCCell.m
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kTweetCell_LikeUserCCell_Height 25.0

#import "TweetLikeUserCCell.h"
#import "UIView+Common.h"
#import "NSString+Common.h"

@interface TweetLikeUserCCell()

@property (nonatomic, strong) User *curUser;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *likesLabel;

@end

@implementation TweetLikeUserCCell

- (void)configWithUser:(User *)user likesNum:(NSNumber *)likes {
    self.curUser = user;
    self.likes = likes;
    if (!self.imgView) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kTweetCell_LikeUserCCell_Height, kTweetCell_LikeUserCCell_Height)];
        [self.imgView doCircleFrame];
        [self.contentView addSubview:self.imgView];
    }
    
    if (_curUser) {
        [self.imgView sd_setImageWithURL:[_curUser.avatar urlImageWithCodePathResizeToView:_imgView] placeholderImage:kPlaceholderMonkeyRoundView(_imgView)];
        if (_likesLabel) {
            _likesLabel.hidden = YES;
        }

    }else {
        [self.imgView sd_setImageWithURL:nil];
        [self.imgView setImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xdadada"]]];

        if (!_likesLabel) {
            _likesLabel = [[UILabel alloc] initWithFrame:_imgView.frame];
            _likesLabel.backgroundColor = [UIColor clearColor];
            _likesLabel.textColor = [UIColor whiteColor];
            _likesLabel.font = [UIFont systemFontOfSize:15];
            _likesLabel.minimumScaleFactor = 0.5;
            _likesLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_likesLabel];
        }
        _likesLabel.text = [NSString stringWithFormat:@"%d", _likes.intValue];
        _likesLabel.hidden = NO;
    }
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
}
@end
