//
//  AppDelegate.h
//  Coding
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setupTabViewController;
- (void)setupLoginViewController;
- (void)setupIntroductionViewController;

- (NSURL *)applicationDocumentsDirectory;

/**
 *  注册推送
 */
- (void)registerPush;

@end

