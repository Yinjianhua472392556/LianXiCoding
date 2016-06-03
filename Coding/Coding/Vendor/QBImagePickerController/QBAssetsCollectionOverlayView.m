//
//  QBAssetsCollectionOverlayView.m
//  Coding
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QBAssetsCollectionOverlayView.h"

// Views
#import "QBAssetsCollectionCheckmarkView.h"

@interface QBAssetsCollectionOverlayView()
@property (nonatomic, strong) QBAssetsCollectionCheckmarkView *checkmarkView;
@end

@implementation QBAssetsCollectionOverlayView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        // View settings
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];

        
        // Create a checkmark view
        QBAssetsCollectionCheckmarkView *checkmarkView = [[QBAssetsCollectionCheckmarkView alloc] initWithFrame:CGRectMake(self.bounds.size.width - (4 + 24), self.bounds.size.height - (4.0 + 24.0), 24, 24)];
        checkmarkView.autoresizingMask = UIViewAutoresizingNone;
        
        checkmarkView.layer.shadowColor = [UIColor grayColor].CGColor;
        checkmarkView.layer.shadowOffset = CGSizeMake(0, 0);
        checkmarkView.layer.shadowOpacity = 0.6;
        checkmarkView.layer.shadowRadius = 2.0;
        
        [self addSubview:checkmarkView];
        self.checkmarkView = checkmarkView;

    }
    
    return self;
}

@end
