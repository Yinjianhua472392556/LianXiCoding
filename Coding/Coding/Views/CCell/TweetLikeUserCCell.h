//
//  TweetLikeUserCCell.h
//  Coding
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kCCellIdentifier_TweetLikeUser @"TweetLikeUserCCell"

#import <UIKit/UIKit.h>
#import "User.h"

@interface TweetLikeUserCCell : UICollectionViewCell

- (void)configWithUser:(User *)user likesNum:(NSNumber *)likes;

@end
