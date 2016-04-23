//
//  ProjectListCell.h
//  Coding
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 apple. All rights reserved.
//


#define kCellIdentifier_ProjectList @"ProjectListCell"

#import "SWTableViewCell.h"
#import "Projects.h"

@interface ProjectListCell : SWTableViewCell
- (void)setProject:(Project *)project hasSWButtons:(BOOL)hasSWButtons hasBadgeTip:(BOOL)hasBadgeTip hasIndicator:(BOOL)hasIndicator;
+ (CGFloat)cellHeight;

@end
