//
//  RKSwipeBetweenViewControllers.h
//  Coding
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@protocol RKSwipeBetweenViewControllersDelegate <NSObject>

@end

@interface RKSwipeBetweenViewControllers : BaseNavigationController <UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, weak) id<RKSwipeBetweenViewControllersDelegate> navDelegate;
@property (nonatomic, strong, readonly) UIPageViewController *pageController;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) NSArray *buttonText;

+ (instancetype)newSwipeBetweenViewControllers;
- (UIViewController *)curViewController;

@end
