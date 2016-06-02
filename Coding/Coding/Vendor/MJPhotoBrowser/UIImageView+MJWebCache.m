//
//  UIImageView+MJWebCache.m
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIImageView+MJWebCache.h"

@implementation UIImageView (MJWebCache)
- (void)setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (void)setImageURLStr:(NSString *)urlStr placeholder:(UIImage *)placeholder {

    [self setImageURL:[NSURL URLWithString:urlStr] placeholder:placeholder];
}
@end
