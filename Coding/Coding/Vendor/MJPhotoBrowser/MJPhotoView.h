//
//  MJPhotoView.h
//  Coding
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJPhoto,MJPhotoView;

@protocol MJPhotoViewDelegate <NSObject>

- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView;
- (void)photoViewSingleTap:(MJPhotoView *)photoView;

@end

@interface MJPhotoView : UIScrollView<UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) MJPhoto *photo;

// 代理
@property (nonatomic, strong) id<MJPhotoViewDelegate>photoViewDelegate;

@end
