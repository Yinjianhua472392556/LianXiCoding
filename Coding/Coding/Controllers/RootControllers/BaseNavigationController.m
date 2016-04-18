//
//  BaseNavigationController.m
//  Coding
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (BOOL)shouldAutorotate {

    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}

@end
