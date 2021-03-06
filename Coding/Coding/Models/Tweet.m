//
//  Tweet.m
//  Coding
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Tweet.h"
#import "Login.h"

@implementation Tweet

- (instancetype)init {

    self = [super init];
    if (self) {
        _propertyArrayMap = [NSDictionary dictionaryWithObjectsAndKeys:@"Comment", @"comment_list",@"User", @"like_users", nil];
        _canLoadMore = YES;
        _isLoading = _willLoadMore = NO;
        _contentHeight = 1;
    }
    return self;
}

- (void)setContent:(NSString *)content {
    if (_content != content) {
        _htmlMedia = [HtmlMedia htmlMediaWithString:content showType:MediaShowTypeNone];
        _content = _htmlMedia.contentDisplay;
    }
}

- (NSString *)address {
    if (!_address || _address.length == 0) {
        return @"未填写";
    }else {
        return _address;
    }
}

- (NSInteger)numOfLikers {

    return MIN(_like_users.count + 1, MIN(_likes.intValue, [self maxLikerNum]));
}

- (NSInteger)maxLikerNum {

    NSInteger maxNum = 9;
    if (kDevice_Is_iPhone6) {
        maxNum = 11;
    }else if (kDevice_Is_iPhone6Plus) {
        maxNum = 12;
    }
    return maxNum;
}

- (NSInteger)numOfComments {

    return MIN(_comment_list.count, MIN(_comments.intValue, 6));
}

- (BOOL)hasMoreComments {

    return (_comments.intValue > _comment_list.count || _comments.intValue > 5);
}

- (BOOL)hasMoreLikers {

    return (_likes.intValue > _like_users.count || _likes.intValue > [self maxLikerNum] - 1);
}

- (NSString *)toDoLikePath {

    NSString *doCommentPath;
    doCommentPath = [NSString stringWithFormat:@"api/tweet/%d/comment",self.id.intValue];
    return doCommentPath;
}


- (void)changeToLiked:(NSNumber *)liked {

    if (!liked) {
        return;
    }
    
    if (!_liked || ![_liked isEqualToNumber:liked]) {
        _liked = liked;
        User *cur_user = [Login curLoginUser];
        NSPredicate *finalPredicate = [NSPredicate predicateWithFormat:@"global_key == %@", cur_user.global_key];
        if (_liked.boolValue) { //喜欢
            
            if(!_like_users) {
                _like_users = [NSMutableArray arrayWithObject:cur_user];
                _likes = [NSNumber numberWithInteger:_likes.integerValue + 1];
            }else {
                NSArray *fliterArray = [_like_users filteredArrayUsingPredicate:finalPredicate];
                if (!fliterArray || [fliterArray count] <= 0) {
                    [_like_users insertObject:cur_user atIndex:0];
                    _likes = [NSNumber numberWithInteger:_likes.integerValue +1];
                }

            }
            
        }else { //不喜欢
            if (_like_users) {
                NSArray *fliterArray = [_like_users filteredArrayUsingPredicate:finalPredicate];
                if (fliterArray && [fliterArray count] > 0) {
                    [_like_users removeObjectsInArray:fliterArray];
                    _likes = [NSNumber numberWithInteger:_likes.integerValue -1];
                }
            }
        }
    }
}

- (void)addNewComment:(Comment *)comment {

    if (!comment) {
        return;
    }
    if (_comment_list) {
        [_comment_list insertObject:comment atIndex:0];
    }else {
    
        _comment_list = [NSMutableArray arrayWithObject:comment];
    }
    
    _comments = [NSNumber numberWithInteger:_comments.integerValue + 1];
}

- (void)deleteComment:(Comment *)comment{
    if (_comment_list) {
        NSUInteger index = [_comment_list indexOfObject:comment];
        if (index != NSNotFound) {
            [_comment_list removeObjectAtIndex:index];
            _comments = [NSNumber numberWithInteger:_comments.integerValue -1];
        }
    }
}

@end
