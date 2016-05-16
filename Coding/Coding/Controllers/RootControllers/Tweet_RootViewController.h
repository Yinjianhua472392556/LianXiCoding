//
//  Tweet_RootViewController.h
//  Coding
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, Tweet_RootViewControllerType) {
    Tweet_RootViewControllerTypeAll = 0,
    Tweet_RootViewControllerTypeFriend,
    Tweet_RootViewControllerTypeHot,
    Tweet_RootViewControllerTypeMine
};

@interface Tweet_RootViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

+ (instancetype)newTweetVCWithType:(Tweet_RootViewControllerType)type;

@end
