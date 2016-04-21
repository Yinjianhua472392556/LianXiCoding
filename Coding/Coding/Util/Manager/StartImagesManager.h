//
//  StartImagesManager.h
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@class StartImage;
@class Group;

@interface StartImagesManager : NSObject

+ (instancetype)shareManager;

- (StartImage *)randomImage;
- (StartImage *)curImage;

- (void)refreshImagesPlist;
- (void)startDownloadImages;

@end


@interface StartImage : NSObject

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) NSString *fileName, *descriptionStr, *pathDisk;

+ (StartImage *)defautImage;
- (UIImage *)image;
- (void)startDownloadImage;


@end

@interface Group : NSObject
@property (strong, nonatomic) NSString *name, *author;
@end