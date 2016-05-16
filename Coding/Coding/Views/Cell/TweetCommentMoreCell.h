//
//  TweetCommentMoreCell.h
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kCellIdentifier_TweetCommentMore @"TweetCommentMoreCell"


#import <UIKit/UIKit.h>

@interface TweetCommentMoreCell : UITableViewCell

@property (nonatomic, strong) NSNumber *commentNum;
+ (CGFloat)cellHeight;
@end
