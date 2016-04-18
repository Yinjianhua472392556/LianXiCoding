//
//  RootTabViewController.m
//  Coding
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RootTabViewController.h"
#import "Project_RootViewController.h"
#import "MyTask_RootViewController.h"
#import "RKSwipeBetweenViewControllers.h"
#import "Message_RootViewController.h"
#import "Me_RootViewController.h"
#import "BaseNavigationController.h"

@implementation RootTabViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setupViewControllers];
}


#pragma mark Private_M
- (void)setupViewControllers {
    Project_RootViewController *project = [[Project_RootViewController alloc] init];
    UINavigationController *nav_project = [[BaseNavigationController alloc] initWithRootViewController:project];
    MyTask_RootViewController *mytask = [[MyTask_RootViewController alloc] init];
    UINavigationController *nav_mytask = [[BaseNavigationController alloc] initWithRootViewController:mytask];

}

@end
