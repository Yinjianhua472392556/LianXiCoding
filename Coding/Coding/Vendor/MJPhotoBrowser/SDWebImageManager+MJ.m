//
//  SDWebImageManager+MJ.m
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SDWebImageManager+MJ.h"

@implementation SDWebImageManager (MJ)
+ (void)downloadWithURL:(NSURL *)url {

    if (!url) {
        return;
    }
    
    [[self sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
}
@end
