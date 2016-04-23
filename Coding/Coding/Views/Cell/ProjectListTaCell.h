//
//  ProjectListTaCell.h
//  Coding
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kCellIdentifier_ProjectListTaCell @"ProjectListTaCell"

#import <UIKit/UIKit.h>
#import "Projects.h"

@interface ProjectListTaCell : UITableViewCell
@property (nonatomic, strong) Project *project;
+ (CGFloat)cellHeight;

@end
