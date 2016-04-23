//
//  Project_RootViewController.h
//  Coding
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "iCarousel.h"
#import "XTSegmentControl.h"
#import "Projects.h"

@interface Project_RootViewController : BaseViewController<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic, strong) NSArray *segmentItems;
@property (nonatomic, assign) BOOL icarouselScrollEnabled;

@end
