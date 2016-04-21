//
//  UITapImageView.m
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UITapImageView.h"

@interface UITapImageView()
@property (nonatomic, copy) void(^tapAction)(id);
@end

@implementation UITapImageView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (instancetype)init {

    return [self initWithFrame:CGRectZero];
}

- (void)tap {
    if (self.tapAction) {
        self.tapAction(self);
    }
}

- (void)addTapBlock:(void (^)(id))tapAction {

    self.tapAction = tapAction;
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

- (void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void (^)(id))tapAction {

    [self sd_setImageWithURL:imgUrl placeholderImage:placeholderImage];
    [self addTapBlock:tapAction];
    
}
@end
