//
//  MJPhoto.h
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJPhoto : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image; // 完整的图片
@property (nonatomic, strong) UIImageView *srcImageView; // 来源view
@property (nonatomic, strong, readonly) UIImage *placeholder;
@property (nonatomic, strong, readonly) UIImage *capture;

// 是否已经保存到相册
@property (nonatomic, assign) BOOL save;
@property (nonatomic, assign) int index; // 索引

@end
