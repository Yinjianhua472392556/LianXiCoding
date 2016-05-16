//
//  UIMessageInputView.h
//  Coding
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef NS_ENUM(NSUInteger, UIMessageInputViewContentType) {
    UIMessageInputViewContentTypeTweet = 0,
    UIMessageInputViewContentTypePriMsg,
    UIMessageInputViewContentTypeTopic,
    UIMessageInputViewContentTypeTask
};

typedef NS_ENUM(NSUInteger, UIMessageInputViewState) {
    UIMessageInputViewStateSystem,
    UIMessageInputViewStateEmotion,
    UIMessageInputViewStateAdd,
    UIMessageInputViewStateVoice
};

@protocol UIMessageInputViewDelegate;



@interface UIMessageInputView : UIView

@property (nonatomic, weak) id<UIMessageInputViewDelegate>delegate;
@property (nonatomic, strong) NSNumber *commentOfId;
@property (strong, nonatomic) User *toUser;

+ (instancetype)messageInputViewWithType:(UIMessageInputViewContentType)type;
+ (instancetype)messageInputViewWithType:(UIMessageInputViewContentType)type
                             placeHolder:(NSString *)placeHolder;

- (void)prepareToDismiss;
- (void)prepareToShow;
- (BOOL)notAndBecomeFirstResponder;
- (BOOL)isAndResignFirstResponder;
- (BOOL)isCustomFirstResponder;

@end


@protocol UIMessageInputViewDelegate <NSObject>

@optional

@end
