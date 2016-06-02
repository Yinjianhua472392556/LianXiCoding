//
//  UIImageView+MJWebCache.h
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIImageView (MJWebCache)

- (void)setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder;
- (void)setImageURLStr:(NSString *)urlStr placeholder:(UIImage *)placeholder;

@end
