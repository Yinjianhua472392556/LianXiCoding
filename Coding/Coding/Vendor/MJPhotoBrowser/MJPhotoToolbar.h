//
//  MJPhotoToolbar.h
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJPhotoToolbar : UIView
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;

// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property (nonatomic, assign) NSUInteger showSaveBtn;

@end
