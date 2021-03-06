//
//  TweetCommentMoreCell.m
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//
#define kTweet_CommentFont [UIFont systemFontOfSize:14]

#import "TweetCommentMoreCell.h"
#import "UIColor+UIColor_Expanded.h"

@interface TweetCommentMoreCell()
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *commentIconView, *splitLineView;
@end

@implementation TweetCommentMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        if (!_commentIconView) {
            _commentIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 13, 13)];
            _commentIconView.image = [UIImage imageNamed:@"tweet_more_comment_icon"];
            [self.contentView addSubview:_commentIconView];
        }
        
        if (!_contentLabel) {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 245, 20)];
            _contentLabel.backgroundColor = [UIColor clearColor];
            _contentLabel.font = kTweet_CommentFont;
            _contentLabel.textColor = [UIColor colorWithHexString:@"0x222222"];
            [self.contentView addSubview:_contentLabel];
        }
        
        if (!_splitLineView) {
            _splitLineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 250, 1)];
            _splitLineView.image = [UIImage imageNamed:@"splitlineImg"];
            [self.contentView addSubview:_splitLineView];
            [_splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(10);
                make.top.right.equalTo(self.contentView);
                make.height.mas_equalTo(1.0);
            }];

        }

    }
    
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    self.contentLabel.text = [NSString stringWithFormat:@"查看全部%d条评论", _commentNum.intValue];
}

+ (CGFloat)cellHeight {

    return 12 + 10 * 2;
}

@end
