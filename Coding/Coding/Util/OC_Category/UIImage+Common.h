//
//  UIImage+Common.h
//  Coding
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (Common)
+ (UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset;
+ (UIImage *)imageWithFileType:(NSString *)fileType;


-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
-(UIImage*)scaledToMaxSize:(CGSize )size;

@end
