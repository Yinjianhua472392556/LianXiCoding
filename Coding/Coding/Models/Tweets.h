//
//  Tweets.h
//  Coding
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Tweet.h"

typedef NS_ENUM(NSUInteger, TweetType) {
    TweetTypePublicTime = 0,
    TweetTypeUserFriends,
    TweetTypePublicHot,
    TweetTypeUserSingle
};

@interface Tweets : NSObject

@property (nonatomic, strong) NSNumber *last_id;
@property (nonatomic, assign) BOOL canLoadMore, willLoadMore, isLoading;
@property (nonatomic, assign) TweetType tweetType;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) User *curUser;
@property (nonatomic, strong) Tweet *nextTweet;

+ (Tweets *)tweetsWithType:(TweetType)tweetType;
+ (Tweets *)tweetsWithUser:(User *)curUser;

- (NSString *)localResponsePath;
- (void)configWithTweets:(NSArray *)responseA;
- (NSString *)toPath;
- (NSDictionary *)toParams;

@end
