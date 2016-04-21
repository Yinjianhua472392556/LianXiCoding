//
//  LoginViewController.m
//  Coding
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "Login2FATipCell.h"
#import "Input_OnlyText_Cell.h"
#import "UIButton+Bootstrap.h"
#import "StartImagesManager.h"
#import <NYXImagesKit/NYXImagesKit.h>
#import "UIView+Common.h"
#import <UIImage+BlurredFrame/UIImage+BlurredFrame.h>
#import "Coding_NetAPIManager.h"
#import "NSString+Common.h"
#import "EaseInputTipsView.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (nonatomic, strong) Login *myLogin;
@property (nonatomic, strong) TPKeyboardAvoidingTableView *myTableView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) BOOL captchaNeeded;
@property (nonatomic, strong) UIButton *loginBtn, *buttonFor2FA;
@property (nonatomic, strong) EaseInputTipsView *inputTipsView;

@property (nonatomic, strong) UIButton *dismissButton;

@property (nonatomic, strong) UIImageView *iconUserView, *bgBlurredView;
@property (nonatomic, assign) BOOL is2FAUI;
@property (strong, nonatomic) NSString *otpCode;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.myLogin = [[Login alloc] init];
    self.myLogin.email = [Login preUserEmail];
    _captchaNeeded = NO;
    
    //    添加myTableView

    _myTableView = ({
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [tableView registerClass:[Login2FATipCell class] forCellReuseIdentifier:kCellIdentifier_Login2FATipCell];
        [tableView registerNib:[UINib nibWithNibName:kCellIdentifier_Input_OnlyText_Cell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCellIdentifier_Input_OnlyText_Cell];
        tableView.backgroundView = self.bgBlurredView;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    
    self.myTableView.contentInset = UIEdgeInsetsMake(-kHigher_iOS_6_1_DIS(20), 0, 0, 0);
    self.myTableView.tableHeaderView = [self customHeaderView];
    self.myTableView.tableFooterView = [self customFooterView];
    [self configBottomView];
    [self showdismissButton:self.showDismissButton];
    [self buttonFor2FA];
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self refreshCaptchaNeeded];
    [self refreshIconUserImage];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (!_inputTipsView) {
        _inputTipsView = ({
            EaseInputTipsView *tipsView = [EaseInputTipsView tipsViewWithType:EaseInputTipsViewTypeLogin];
            
            tipsView.valueStr = nil;
            __weak typeof(self) weakSelf = self;
            
            tipsView.selectedStringBlock = ^(NSString *valueStr) {
            
                [weakSelf.view endEditing:YES];
                weakSelf.myLogin.email = valueStr;
                [weakSelf refreshIconUserImage];
                [weakSelf.myTableView reloadData];
            };
            
            UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [tipsView setY:CGRectGetMaxY(cell.frame) - 0.5];
            [_myTableView addSubview:tipsView];
            tipsView;
        
        });
    }
}


- (void)refreshCaptchaNeeded {

    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] request_CaptchaNeededWithPath:@"api/captcha/login" andBlock:^(id data, NSError *error) {
       
        if (data) {
            NSNumber *captchaNeededResult = (NSNumber *)data;
            if (captchaNeededResult) {
                weakSelf.captchaNeeded = captchaNeededResult.boolValue;
            }
            
            [weakSelf.myTableView reloadData];
        }
    }];
    
}

- (void)refreshIconUserImage {

    NSString *textStr = self.myLogin.email;
    if (textStr) {
        User *curUser = [Login userWithGlobaykeyOrEmail:textStr];
        if (curUser && curUser.avatar) {
            [self.iconUserView sd_setImageWithURL:[curUser.avatar urlImageWithCodePathResizeToView:self.iconUserView] placeholderImage:[UIImage imageNamed:@"icon_user_monkey"]];
        }
    }
}

- (UIButton *)buttonFor2FA {
    if (!_buttonFor2FA) {
        _buttonFor2FA = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 100, 20, 80, 50)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
            [button setTitle:@"  两步验证" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"twoFABtn_Nav"] forState:UIControlStateNormal];

            button;
        });
        [_buttonFor2FA addTarget:self action:@selector(goTo2FAVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_buttonFor2FA];
    }
    return _buttonFor2FA;
}

- (void)setCaptchaNeeded:(BOOL)captchaNeeded {

    _captchaNeeded = captchaNeeded;
    if (!captchaNeeded) {
        self.myLogin.j_captcha = nil;
    }
}

- (UIImageView *)bgBlurredView {

    if (!_bgBlurredView) {
        //背景图片

        UIImageView *bgView = [[UIImageView alloc] initWithFrame:kScreen_Bounds];
        bgView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *bgImage = [[StartImagesManager shareManager] curImage].image;
        
        CGSize bgImageSize = bgImage.size, bgViewSize = bgView.frame.size;
        if (bgImageSize.width > bgViewSize.width && bgImageSize.height > bgViewSize.height) {
            bgImage = [bgImage scaleToSize:bgViewSize usingMode:NYXResizeModeAspectFill];
        }
        bgImage = [bgImage applyLightEffectAtFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
        bgView.image = bgImage;
        //黑色遮罩
        UIColor *blackColor = [UIColor blackColor];
        [bgView addGradientLayerWithColors:@[(id)[blackColor colorWithAlphaComponent:0.3].CGColor,
                                             (id)[blackColor colorWithAlphaComponent:0.3].CGColor]
                                 locations:nil
                                startPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 1.0)];
        _bgBlurredView = bgView;

    }
    return _bgBlurredView;
}

- (void)showdismissButton:(BOOL)willShow {

    self.dismissButton.hidden = !willShow;
    if (!self.dismissButton && willShow) {
        self.dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
        [self.dismissButton setImage:[UIImage imageNamed:@"dismissBtn_Nav"] forState:UIControlStateNormal];
        [self.dismissButton addTarget:self action:@selector(dismissButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.dismissButton];
    }
}

#pragma mark - Table view Header Footer
- (UIView *)customHeaderView {
    CGFloat iconUserViewWidth;
    if (kDevice_Is_iPhone6Plus) {
        iconUserViewWidth = 100;
    }else if (kDevice_Is_iPhone6){
        iconUserViewWidth = 90;
    }else{
        iconUserViewWidth = 75;
    }
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height/3)];
    _iconUserView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconUserViewWidth, iconUserViewWidth)];
    _iconUserView.contentMode = UIViewContentModeScaleAspectFit;
    _iconUserView.layer.masksToBounds = YES;
    _iconUserView.layer.cornerRadius = _iconUserView.frame.size.width / 2;
    _iconUserView.layer.borderWidth = 2;
    _iconUserView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [headerV addSubview:_iconUserView];
    [_iconUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(iconUserViewWidth, iconUserViewWidth));
        make.centerX.equalTo(headerV);
        make.centerY.equalTo(headerV).offset(30);
    }];
    
    [_iconUserView setImage:[UIImage imageNamed:@"icon_user_monkey"]];
    return headerV;
}

- (UIView *)customFooterView {
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 150)];
    _loginBtn = [UIButton buttonWithStyle:StrapSuccessStyle andTitle:@"登录" andFrame:CGRectMake(kLoginPaddingLeftWidth, 20, kScreen_Width-kLoginPaddingLeftWidth*2, 45) target:self action:@selector(sendLogin)];
    [footerV addSubview:_loginBtn];
    
    UIButton *cannotLoginBtn = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.5] forState:UIControlStateHighlighted];
        [button setTitle:@"无法登录？" forState:UIControlStateNormal];
        [footerV addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.centerX.equalTo(footerV);
            make.top.equalTo(_loginBtn.mas_bottom).offset(20);
        }];
        button;
    });
    
    [cannotLoginBtn addTarget:self action:@selector(cannotLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return footerV;
  
}

#pragma mark BottomView

- (void)configBottomView {

    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 60, kScreen_Width, 60)];
        _bottomView.backgroundColor = [UIColor clearColor];
        UIButton *registerBtn = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.5] forState:UIControlStateHighlighted];
            [button setTitle:@"去注册" forState:UIControlStateNormal];
            [_bottomView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(100, 300));
                make.center.equalTo(_bottomView);
            }];

            button;
        });
        
        [registerBtn addTarget:self action:@selector(goRegisterVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomView];
    }
}

#pragma mark Btn Clicked
- (void)sendLogin {
    
    [self.view endEditing:YES];
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGSize captchaViewSize = _loginBtn.bounds.size;
        _activityIndicator.hidesWhenStopped = YES;
        [_activityIndicator setCenter:CGPointMake(captchaViewSize.width/2, captchaViewSize.height/2)];
        [_loginBtn addSubview:_activityIndicator];

    }
    [_activityIndicator startAnimating];
    
    __weak typeof(self) weakSelf = self;
    _loginBtn.enabled = NO;
    
    [[Coding_NetAPIManager sharedManager] request_Login_WithParams:[self.myLogin toParams] andBlock:^(id data, NSError *error) {
        weakSelf.loginBtn.enabled = YES;
        if (data) {
            [Login setPreUserEmail:self.myLogin.email]; //记住登录账号
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate setupTabViewController];
        }else {
            NSString *global_key = error.userInfo[@"msg"][@"two_factor_auth_code_not_empty"];
            if (global_key.length > 0) {
                
            }else {
                [self showError:error];
                [weakSelf refreshCaptchaNeeded];
            }
        }
    }];
}

- (void)cannotLoginBtnClicked:(id)sender {

    
}

- (void)goRegisterVC:(id)sender {

}

- (void)dismissButtonClicked {

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _captchaNeeded? 3: 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    Input_OnlyText_Cell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Input_OnlyText_Cell forIndexPath:indexPath];
    cell.isForLoginVC = YES;
    
    __weak typeof(self) weakSelf = self;
          if (indexPath.row == 0) {
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            [cell configWithPlaceholder:@" 电子邮箱/个性后缀" andValue:self.myLogin.email];
            cell.textValueChangedBlock = ^(NSString *valueStr){
                weakSelf.inputTipsView.valueStr = valueStr;
                weakSelf.inputTipsView.active = YES;
                weakSelf.myLogin.email = valueStr;
                [weakSelf.iconUserView setImage:[UIImage imageNamed:@"icon_user_monkey"]];
            };
            cell.editDidEndBlock = ^(NSString *textStr){
                weakSelf.inputTipsView.active = NO;
                [weakSelf refreshIconUserImage];
            };
        }else if (indexPath.row == 1){
            [cell configWithPlaceholder:@" 密码" andValue:self.myLogin.password];
            cell.textField.secureTextEntry = YES;
            cell.textValueChangedBlock = ^(NSString *valueStr){
                weakSelf.myLogin.password = valueStr;
            };
        }else{
            cell.isCaptcha = YES;
            [cell configWithPlaceholder:@" 验证码" andValue:self.myLogin.j_captcha];
            cell.textValueChangedBlock = ^(NSString *valueStr){
                weakSelf.myLogin.j_captcha = valueStr;
            };
        }
    
    return cell;
}


@end
