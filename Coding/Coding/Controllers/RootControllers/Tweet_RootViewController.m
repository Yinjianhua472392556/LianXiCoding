//
//  Tweet_RootViewController.m
//  Coding
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Tweet_RootViewController.h"
#import "TweetCell.h"
#import "SVPullToRefresh.h"
#import <RDVTabBarController/RDVTabBarController.h>
#import "ODRefreshControl.h"
#import "UIMessageInputView.h"
#import "CodingBannersView.h"
#import "Tweets.h"
#import "UIView+Common.h"
#import "Coding_NetAPIManager.h"
#import "Comment.h"
#import "Login.h"
#import "UIActionSheet+Common.h"
#import "UITableViewCell+Common.h"


#import "QBImagePickerController.h"
#import "Helper.h"
#import "BaseNavigationController.h"

@interface Tweet_RootViewController ()<UIMessageInputViewDelegate,QBImagePickerControllerDelegate> {
    CGFloat _oldPanOffsetY;
}
@property (nonatomic, assign) NSInteger curIndex; //保存传进来的type(做tweetsDict字典的键值)
@property (nonatomic, strong) NSMutableDictionary *tweetsDict; //用于确定拿神马冒泡(Tweet_RootViewControllerTypeFriend，Tweet_RootViewControllerTypeHot)
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;


//评论
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, strong) Tweet *commentTweet;
@property (nonatomic, assign) NSInteger commentIndex;
@property (nonatomic, strong) UIView *commentSender;
@property (nonatomic, strong) User *commentToUser;


//删冒泡
@property (nonatomic, strong) Tweet *deleteTweet;
@property (nonatomic, assign) NSInteger deleteTweetsIndex;


//Banner
@property (nonatomic, strong) CodingBannersView *myBannersView;

@end

@implementation Tweet_RootViewController

+ (instancetype)newTweetVCWithType:(Tweet_RootViewControllerType)type {

    Tweet_RootViewController *vc = [Tweet_RootViewController new];
    vc.curIndex = type;
    return vc;
}

- (instancetype)init {

    self = [super init];
    if (self) {
        _curIndex = 0;
        _tweetsDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return self;
}


#pragma mark lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加myTableView
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    Class tweetCellClass = [TweetCell class];
    [_myTableView registerClass:tweetCellClass forCellReuseIdentifier:kCellIdentifier_Tweet];
    [self.view addSubview:_myTableView];
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    [_myTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf refreshMore]; //刷新拿到更多数据
    }];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.rdv_tabBarController.tabBar.frame), 0);
    _myTableView.contentInset = insets;
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    //评论
//    _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypeTweet];
//    _myMsgInputView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
//    if (_myMsgInputView) {
//        [_myMsgInputView prepareToDismiss];
//    }
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    [self refreshFirst];
    
    //    键盘
    
//    if (_myMsgInputView) {
//        [_myMsgInputView prepareToShow];
//    }
    
    [self.parentViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tweetBtn_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(sendTweet)]];

}

#pragma mark Refresh M
- (void)refreshMore {

    Tweets *curTweets = [self getCurTweets];
    if (curTweets.isLoading || !curTweets.canLoadMore) {
        return;
    }
    
    curTweets.willLoadMore = YES;
    [self sendRequest];
}

- (void)refresh {

    Tweets *curTweets = [self getCurTweets];
    if (curTweets.isLoading) {
        return;
    }
    
    curTweets.willLoadMore = NO;
    [self sendRequest];
    [self refreshBanner];
}

- (void)refreshFirst {
    [self.myTableView reloadData];
    if (self.myTableView.contentSize.height <= CGRectGetHeight(self.myTableView.bounds) - 50) {
        [self hideToolBar:NO];
    }
    
    Tweets *curTweets = [self getCurTweets];
    
    if (curTweets) {
        _myTableView.showsInfiniteScrolling = curTweets.canLoadMore;
    }else { //没有值时，curTweets = [Tweets tweetsWithType:_curIndex];
        curTweets = [Tweets tweetsWithType:_curIndex];
        [self saveCurTweets:curTweets]; //保存
    }
    
    if (curTweets.list.count <= 0) {
        [self refresh];
    }
    
    if (!curTweets.isLoading) {
        [self.view configBlankPage:EaseBlankPageTypeTweet hasData:(curTweets.list.count > 0) hasError:NO reloadButtonBlock:^(id sender) {
            [self sendRequest];
        }];
    }
}

- (void)sendRequest {
    Tweets *curTweets = [self getCurTweets];
    if (curTweets.list.count <= 0) {
        [self.view beginLoading];
    }
    
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] request_Tweets_WithObj:curTweets andBlock:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.myTableView.infiniteScrollingView stopAnimating];
        if (data) {
            [curTweets configWithTweets:data];  //处理返回的请求数据，其中data为一个Tweet数组,在此方法中将每一个Tweet加入到Tweets的list（NSMutableArray）属性中
            [weakSelf.myTableView reloadData];
            weakSelf.myTableView.showsInfiniteScrolling = curTweets.canLoadMore;
        }
        
        [weakSelf.view configBlankPage:EaseBlankPageTypeTweet hasData:(curTweets.list.count > 0) hasError:(error != nil) reloadButtonBlock:^(id sender) {
            [weakSelf sendRequest];
        }];
    }];
}


#pragma mark M

- (Tweets *)getCurTweets {

    return [_tweetsDict objectForKey:[NSNumber numberWithInteger:_curIndex]];
}

- (void)saveCurTweets:(Tweets *)curTweets {

    [_tweetsDict setObject:curTweets forKey:[NSNumber numberWithInteger:_curIndex]];
}

- (void)sendTweet { //发送冒泡
    //相册
//    if (![Helper checkPhotoLibraryAuthorizationStatus]) {
//        return;
//    }
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    [imagePickerController.selectedAssetURLs removeAllObjects];
    imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9;
    UINavigationController *navigaitonController = [[BaseNavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigaitonController animated:YES completion:nil];

}

- (void)deleteTweet:(Tweet *)curTweet outTweetsIndex:(NSInteger)outTweetsIndex { //删除所有冒泡消息中的某条冒泡

}

- (void)deleteComment:(Comment *)comment ofTweet:(Tweet *)tweet { //删掉某一冒泡中的某一评论

}

#pragma mark Banner

- (void)refreshBanner {
    if (self.curIndex != Tweet_RootViewControllerTypeAll) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    if (!_myBannersView) {
        _myBannersView = [CodingBannersView new];
        _myBannersView.tapActionBlock = ^(CodingBanner *tapedBanner) {
            [weakSelf goToBanner:tapedBanner];
            NSLog(@"%@",tapedBanner);
        };
        
        _myTableView.tableHeaderView = _myBannersView;
    }
    
    [[Coding_NetAPIManager sharedManager] request_BannersWithBlock:^(id data, NSError *error) {
        if (data) {
            weakSelf.myBannersView.curBannerList = data;
        }
    }];
}

- (void)goToBanner:(CodingBanner *)tapedBanner {
    [self analyseLinkStr:tapedBanner.link];
}

#pragma mark ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    if (scrollView == _myTableView) {
//        [self.myMsgInputView isAndResignFirstResponder];
        _oldPanOffsetY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    _oldPanOffsetY = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentSize.height <= CGRectGetHeight(scrollView.bounds) - 50) {
        [self hideToolBar:NO];
        return;
    }else if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
    
        CGFloat nowPanOffsetY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
        CGFloat diffPanOffsetY = nowPanOffsetY - _oldPanOffsetY;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        if (ABS(diffPanOffsetY) > 50.f) {
            [self hideToolBar:(diffPanOffsetY < 0.f && contentOffsetY > 0)];
            _oldPanOffsetY = nowPanOffsetY;
        }
    }
}

- (void)hideToolBar:(BOOL)hide {
    if (hide != self.rdv_tabBarController.tabBarHidden) {
        Tweets *curTweets = [self getCurTweets];
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, (hide? (curTweets.canLoadMore? 60.0: 0.0):CGRectGetHeight(self.rdv_tabBarController.tabBar.frame)), 0);
        self.myTableView.contentInset = contentInsets;
        [self.rdv_tabBarController setTabBarHidden:hide animated:YES];
    }
}




#pragma mark UIMessageInputViewDelegate


#pragma mark - search



#pragma mark TableM

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Tweets *curTweets = [self getCurTweets];
    if (curTweets && curTweets.list) {
        return [curTweets.list count];
    }else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Tweet forIndexPath:indexPath];
    Tweets *curTweets = [self getCurTweets];
    [cell setTweet:[curTweets.list objectAtIndex:indexPath.row] needTopView:(_curIndex == Tweet_RootViewControllerTypeAll || indexPath.row != 0)];
    cell.outTweetsIndex = _curIndex;
    
    __weak typeof(self) weakSelf = self;
    cell.commentClickedBlock = ^(Tweet *tweet, NSInteger index, id sender) {
    
//        if ([self.myMsgInputView isAndResignFirstResponder]) {
//            return ;
//        }
        
        weakSelf.commentTweet = tweet;
        weakSelf.commentIndex = index;
        weakSelf.commentSender = sender;
        
//        weakSelf.myMsgInputView.commentOfId = tweet.id;
        
        if (weakSelf.commentIndex >= 0) {
            
            weakSelf.commentToUser = ((Comment *)[weakSelf.commentTweet.comment_list objectAtIndex:weakSelf.commentIndex]).owner;
            
            if ([Login isLoginUserGlobalKey:weakSelf.commentToUser.global_key]) {
                ESWeakSelf
                UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetCustomWithTitle:@"删除此评论" buttonTitles:nil destructiveTitle:@"确认删除" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
                   ESStrongSelf
                    if (index == 0 && _self.commentIndex >= 0) {
                        Comment *comment = [_self.commentTweet.comment_list objectAtIndex:_self.commentIndex];
                        [_self deleteComment:comment ofTweet:_self.commentTweet];
                    }
                }];
                
                [actionSheet showInView:self.view];
                return;
            }
            
        }else {
        
//            weakSelf.myMsgInputView.toUser = nil;
        }
        
//        [_myMsgInputView notAndBecomeFirstResponder];
    };
    
    cell.likeBtnClickedBlock = ^(Tweet *tweet) {
        [weakSelf.myTableView reloadData];
    };
    
    cell.userBtnClickedBlock = ^(User *curUser) {
    
    };
    
    cell.moreLikersBtnClickedBlock = ^(Tweet *curTweet) {
    
    };
    
    cell.deleteClickedBlock = ^(Tweet *curTweet, NSInteger outTweetsIndex){
    
//        if ([self.myMsgInputView isAndResignFirstResponder]) {
//            return ;
//        }
        self.deleteTweet = curTweet;
        self.deleteTweetsIndex = outTweetsIndex;
        ESWeakSelf
        UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetCustomWithTitle:@"删除此冒泡" buttonTitles:nil destructiveTitle:@"确认删除" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            ESStrongSelf
            if (index == 0) {
                [_self deleteTweet:_self.deleteTweet outTweetsIndex:_self.deleteTweetsIndex];
            }
        }];
        
        [actionSheet showInView:self.view];
    };
    
    cell.goToDetailTweetBlock = ^(Tweet *curTweet){
    
        [self goToDetailWithTweet:curTweet];
    };
    
    cell.refreshSingleCCellBlock = ^{
    
        [weakSelf.myTableView reloadData];
    };
    
    cell.mediaItemClickedBlock = ^(HtmlMediaItem *curItem) {
        [weakSelf analyseLinkStr:curItem.href];
    };
    
    cell.locationClickedBlock = ^(Tweet *curTweet) {
    
    };
    
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
   
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    Tweets *curTweets = [self getCurTweets];
    return [TweetCell cellHeightWithObj:[curTweets.list objectAtIndex:indexPath.row] needTopView:(_curIndex == Tweet_RootViewControllerTypeAll || indexPath.row != 0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Tweets *curTweets = [self getCurTweets];
    Tweet *toTweet = [curTweets.list objectAtIndex:indexPath.row];
    [self goToDetailWithTweet:toTweet];
}




- (void)goToDetailWithTweet:(Tweet *)curTweet {

    
}

- (void)analyseLinkStr:(NSString *)linkStr {
    
}


#pragma mark Comment To Tweet


#pragma mark -
#pragma mark UISearchBarDelegate Support


#pragma mark -
#pragma mark UISearchDisplayDelegate Support

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    NSLog(@"didSelectAssets %@",assets);
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
