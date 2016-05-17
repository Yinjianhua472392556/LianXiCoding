//
//  TweetMediaItemCCell.m
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kTweetMediaItemCCell_Width ((kScreen_Width - 36.0)/3.0)

#import "TweetMediaItemCCell.h"
#import "NSString+Common.h"

@implementation TweetMediaItemCCell
- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setCurMediaItem:(HtmlMediaItem *)curMediaItem {

    if (!_imgView) {
        _imgView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, kTweetMediaItemCCell_Width, kTweetMediaItemCCell_Width)];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.clipsToBounds = YES;
        [self.contentView addSubview:_imgView];
    }
    
    if (_curMediaItem != curMediaItem) {
        _curMediaItem = curMediaItem;
        [self.imgView sd_setImageWithURL:[_curMediaItem.src urlImageWithCodePathResize:2*kTweetMediaItemCCell_Width crop:YES] placeholderImage:kPlaceholderCodingSquareWidth(80.0)  options:SDWebImageRetryFailed];
        //        gifMark
        if ([self.curMediaItem isGif]) {
            if (!_gifMarkView) {
                _gifMarkView = ({
                    UIImageView *imgView = [UIImageView new];
                    imgView.image = [UIImage imageNamed:@"gif_mark"];
                    [self.imgView addSubview:imgView];
                    @weakify(self);
                    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                        @strongify(self);
                        make.size.mas_equalTo(CGSizeMake(24, 13));
                        make.right.bottom.equalTo(self.imgView).offset(0);
                    }];
                    imgView;
                });
            }
            self.gifMarkView.hidden = NO;
        }else {
            self.gifMarkView.hidden = YES;
        }

    }
}

+ (CGSize)ccellSizeWithObj:(id)obj {

    CGSize itemSize;
    if ([obj isKindOfClass:[HtmlMediaItem class]]) {
        itemSize = CGSizeMake(kTweetMediaItemCCell_Width, kTweetMediaItemCCell_Width);
    }
    return itemSize;
}

- (void)layoutSubviews {

    [super layoutSubviews];
}
@end
