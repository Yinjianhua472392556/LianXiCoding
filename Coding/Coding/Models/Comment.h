//
//  Comment.h
//  Coding
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HtmlMedia.h"
typedef NS_ENUM(NSUInteger, CommentSendType) {
    CommentSendTypeSuccess = 0,
    CommentSendTypeIng,
    CommentSendTypeFail,
};

@interface Comment : NSObject
@property (readwrite, nonatomic, strong) NSString *content;
@property (readwrite, nonatomic, strong) User *owner;
@property (readwrite, nonatomic, strong) NSNumber *id, *owner_id, *tweet_id;
@property (readwrite, nonatomic, strong) NSDate *created_at;
@property (readwrite, nonatomic, strong) HtmlMedia *htmlMedia;

@end
