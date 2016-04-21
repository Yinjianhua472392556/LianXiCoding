//
//  Input_OnlyText_Cell.h
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//
#define kCellIdentifier_Input_OnlyText_Cell @"Input_OnlyText_Cell"

#import <UIKit/UIKit.h>
#import "UITapImageView.h"

@interface Input_OnlyText_Cell : UITableViewCell

@property (nonatomic, assign) BOOL isCaptcha, isForLoginVC;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITapImageView *captchaView;
@property (nonatomic, strong) UIImage *captchaImage;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@property (nonatomic, copy) void (^textValueChangedBlock)(NSString *);
@property (nonatomic, copy) void (^editDidEndBlock)(NSString *);

- (IBAction)editDidBegin:(UITextField *)sender;
- (IBAction)editDidEnd:(id)sender;
- (IBAction)textValueChanged:(id)sender;
- (IBAction)clearBtnClicked:(id)sender;

- (void)configWithPlaceholder:(NSString *)phStr andValue:(NSString *)valueStr;

- (void)refreshCaptchaImage;
@end
