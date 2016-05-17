//
//  Tweet.h
//  Coding
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HtmlMedia.h"
#import "Comment.h"
@interface Tweet : NSObject

@property (readwrite, nonatomic, strong) NSString *content, *device, *location, *coord, *address;

@property (readwrite, nonatomic, strong) NSNumber *liked, *activity_id, *id, *comments, *likes;

@property (readwrite, nonatomic, strong) NSDate *created_at;
@property (readwrite, nonatomic, strong) User *owner;

@property (readwrite, nonatomic, strong) NSMutableArray *comment_list, *like_users;
@property (readwrite, nonatomic, strong) NSDictionary *propertyArrayMap;
@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;
@property (readwrite, nonatomic, strong) HtmlMedia *htmlMedia;


@property (readonly, nonatomic, strong) NSMutableArray *tweetImages;
@property (readwrite, nonatomic, strong) NSMutableArray *selectedAssetURLs;
@property (readwrite, nonatomic, strong) NSString *tweetContent;
@property (readwrite, nonatomic, strong) NSString *nextCommentStr;
@property (assign, nonatomic) CGFloat contentHeight;

@property (strong, nonatomic) NSString *user_global_key, *pp_id;

+(Tweet *)tweetForSend;
- (void)saveSendData;

- (NSInteger)numOfLikers;
- (NSInteger)numOfComments;
- (BOOL)hasMoreComments;
- (BOOL)hasMoreLikers;

- (NSString *)toDoLikePath;
- (void)changeToLiked:(NSNumber *)liked;

- (void)addNewComment:(Comment *)comment;
- (void)deleteComment:(Comment *)comment;


@end
