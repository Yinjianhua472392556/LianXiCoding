//
//  MJPhoto.m
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MJPhoto.h"

@implementation MJPhoto

- (UIImage *)capture:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView {

    _srcImageView = srcImageView;
    _placeholder = srcImageView.image;
    if (srcImageView.clipsToBounds) {
        _capture = [self capture:srcImageView];
    }
    
}

@end
