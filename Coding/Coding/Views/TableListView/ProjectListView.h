//
//  ProjectListView.h
//  Coding
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projects.h"

typedef void(^ProjectListViewBlock)(Project *project);

@interface ProjectListView : UIView<UITableViewDelegate,UITableViewDataSource>

- (instancetype)initWithFrame:(CGRect)frame projects:(Projects *)projects block:(ProjectListViewBlock)block tabBarHeight:(CGFloat)tabBarHeight;
- (void)setProjects:(Projects *)projects;
- (void)refreshUI;
- (void)refreshToQueryData;
- (void)tabBarItemClicked;

@end
