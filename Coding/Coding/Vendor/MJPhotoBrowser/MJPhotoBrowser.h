//
//  MJPhotoBrowser.h
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJPhoto.h"

@interface MJPhotoBrowser : NSObject<UIScrollViewDelegate>
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;

// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

// 保存按钮
@property (nonatomic, assign) BOOL showSaveBtn;

// 显示
- (void)show;

@end
