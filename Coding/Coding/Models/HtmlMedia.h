//
//  HtmlMedia.h
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TFHpple.h> //解析html的三方类库(解析html通解析xml)
#import "User.h"

typedef NS_ENUM(NSUInteger, HtmlMediaItemType) {
    HtmlMediaItemType_Image = 0,
    HtmlMediaItemType_Code,
    HtmlMediaItemType_EmotionEmoji,
    HtmlMediaItemType_EmotionMonkey,
    HtmlMediaItemType_ATUser,
    HtmlMediaItemType_AutoLink,
    HtmlMediaItemType_CustomLink
};

typedef NS_ENUM(NSUInteger, MediaShowType) {
    MediaShowTypeNone = 1,
    MediaShowTypeCode = 2,
    MediaShowTypeImage = 3,
    MediaShowTypeMonkey = 5,
    MediaShowTypeImageAndMonkey = 15,
    MediaShowTypeAll = 30
};

@class HtmlMediaItem;

@interface HtmlMedia : NSObject

@property (readwrite, nonatomic, copy) NSString *contentOrigional; //解析出得数据
@property (readwrite, nonatomic, strong) NSMutableString *contentDisplay; //解析出得数据
@property (readwrite, nonatomic, strong) NSMutableArray *mediaItems; //解析出得数据
@property (strong, nonatomic) NSArray *imageItems; //解析出得数据

+ (instancetype)htmlMediaWithString:(NSString *)htmlString showType:(MediaShowType)showType; //初始化需要解析的html
- (instancetype)initWithString:(NSString *)htmlString showType:(MediaShowType)showType; //初始化需要解析的html


//在curString的末尾添加一个media元素
+ (void)addMediaItem:(HtmlMediaItem *)curItem toString:(NSMutableString *)curString andMediaItems:(NSMutableArray *)itemList;
+ (void)addLinkStr:(NSString *)linkStr type:(HtmlMediaItemType)type toString:(NSMutableString *)curString andMediaItems:(NSMutableArray *)itemList;
+ (void)addMediaItemUser:(User *)curUser toString:(NSMutableString *)curString andMediaItems:(NSMutableArray *)itemList;

@end


@interface HtmlMediaItem : NSObject

@property (assign, nonatomic) HtmlMediaItemType type;
@property (assign, nonatomic) MediaShowType showType;
@property (readwrite, nonatomic, strong) NSString *src, *title, *href, *name, *code, *linkStr;
@property (assign, nonatomic) NSRange range;

+ (instancetype)htmlMediaItemWithType:(HtmlMediaItemType)type;
+ (instancetype)htmlMediaItemWithTypeATUser:(User *)curUser mediaRange:(NSRange)curRange;

- (NSString *)displayStr;
- (BOOL)isGif;

@end