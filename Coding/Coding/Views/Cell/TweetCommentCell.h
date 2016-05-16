//
//  TweetCommentCell.h
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kCellIdentifier_TweetComment @"TweetCommentCell"


#import <UIKit/UIKit.h>
#import "UITTTAttributedLabel.h"
#import "Comment.h"

@interface TweetCommentCell : UITableViewCell
@property (nonatomic, strong) UITTTAttributedLabel *commentLabel;
- (void)configWithComment:(Comment *)curComment topLine:(BOOL)has;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
