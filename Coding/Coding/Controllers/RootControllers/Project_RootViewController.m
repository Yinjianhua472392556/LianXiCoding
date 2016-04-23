//
//  Project_RootViewController.m
//  Coding
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Project_RootViewController.h"
#import "ProjectListView.h"
#import "RDVTabBarController.h"
#import "UIView+Common.h"

@interface Project_RootViewController ()
@property (nonatomic, strong) iCarousel *myCarousel;
@property (nonatomic, assign) NSInteger oldSelectedIndex;
@property (nonatomic, strong) NSMutableDictionary *myProjectsDict;
@property (nonatomic, strong) XTSegmentControl *mySegmentControl;

@end

@implementation Project_RootViewController

#pragma mark TabBar
- (void)tabBarItemClicked {

    [super tabBarItemClicked];
    if (_myCarousel.currentItemView && [_myCarousel.currentItemView isKindOfClass:[ProjectListView class]]) {
        ProjectListView *listView = (ProjectListView *)_myCarousel.currentItemView;
        [listView tabBarItemClicked];
    }
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self configSegmentItems];
    
    _oldSelectedIndex = 0;
    self.title = @"项目";
    _myProjectsDict = [[NSMutableDictionary alloc] initWithCapacity:_segmentItems.count];
    
    //添加myCarousel
    iCarousel *icarousel = [[iCarousel alloc] init];
    icarousel.dataSource = self;
    icarousel.delegate = self;
    icarousel.decelerationRate = 1.0;
    icarousel.scrollSpeed = 1.0;
    icarousel.type = iCarouselTypeLinear;
    icarousel.pagingEnabled = YES;
    icarousel.clipsToBounds = YES;
    icarousel.bounceDistance = 0.2;
    [self.view addSubview:icarousel];
    [icarousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kMySegmentControl_Height, 0, 0, 0));
    }];
    
    _myCarousel = icarousel;
    
    //添加滑块
    __weak typeof(_myCarousel) weakCarousel = _myCarousel;
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kMySegmentControl_Height) items:_segmentItems selectedBlock:^(NSInteger index) {
        if (index == _oldSelectedIndex) {
            return ;
        }
        
        [weakCarousel scrollToItemAtIndex:index animated:NO];
    }];
    
    [self.view addSubview:_mySegmentControl];
    [self setupNavBtn];
    
    self.icarouselScrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (_myCarousel) {
        ProjectListView *listView = (ProjectListView *)_myCarousel.currentItemView;
        if (listView) {
            [listView refreshToQueryData];
        }
    }
}

- (void)setIcarouselScrollEnabled:(BOOL)icarouselScrollEnabled {
    _myCarousel.scrollEnabled = icarouselScrollEnabled;
}

- (void)configSegmentItems {
    _segmentItems = @[@"全部项目", @"我参与的", @"我创建的"];
}

- (void)setupNavBtn {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(searchItemClicked:)] animated:NO];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addBtn_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(addItemClicked:)] animated:NO];
}

#pragma mark iCarousel M
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _segmentItems.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    Projects *curPros = [_myProjectsDict objectForKey:[NSNumber numberWithUnsignedInteger:index]];
    if (!curPros) {
        curPros = [self projectsWithIndex:index];
        [_myProjectsDict setObject:curPros forKey:[NSNumber numberWithUnsignedInteger:index]];
    }
    
    ProjectListView *listView = (ProjectListView *)view;
    if (listView) {
        [listView setProjects:curPros];
    }else {
    
        __weak Project_RootViewController *weakSelf = self;
        listView = [[ProjectListView alloc] initWithFrame:carousel.bounds projects:curPros block:^(Project *project) {
            [weakSelf goToProject:project];
            DebugLog(@"\n=====%@", project.name);
        } tabBarHeight:CGRectGetHeight(self.rdv_tabBarController.tabBar.frame)];
    }
    
    [listView setSubScrollsToTop:(index == carousel.currentItemIndex)];
    return listView;
    
}


- (void)carouselDidScroll:(iCarousel *)carousel {
    [self.view endEditing:YES];
    if (_mySegmentControl) {
        float offset = carousel.scrollOffset;
        if (offset > 0) {
            [_mySegmentControl moveIndexWithProgress:offset];
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {

    if (_mySegmentControl) {
        _mySegmentControl.currentIndex = carousel.currentItemIndex;
    }
    
    if (_oldSelectedIndex != carousel.currentItemIndex) {
        _oldSelectedIndex = carousel.currentItemIndex;
        ProjectListView *curView = (ProjectListView *)carousel.currentItemView;
        [curView refreshToQueryData];
    }
    
    [carousel.visibleItemViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSubScrollsToTop:(obj == carousel.currentItemView)];
    }];
}

- (Projects *)projectsWithIndex:(NSUInteger)index {

    return [Projects projectsWithType:index andUser:nil];
}


#pragma mark VC
- (void)goToProject:(Project *)project {

}

@end
