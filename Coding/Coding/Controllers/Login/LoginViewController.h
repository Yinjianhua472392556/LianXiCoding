//
//  LoginViewController.h
//  Coding
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "Login.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>

@interface LoginViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (assign, nonatomic) BOOL showDismissButton;
@end
