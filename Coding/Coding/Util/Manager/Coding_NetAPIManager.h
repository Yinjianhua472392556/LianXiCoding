//
//  Coding_NetAPIManager.h
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Projects.h"
#import "Tweets.h"

typedef NS_ENUM(NSUInteger, VerifyType) {
    VerifyTypeUnknow = 0,
    VerifyTypePassword,
    VerifyTypeTotp,
};

@interface Coding_NetAPIManager : NSObject

+ (instancetype)sharedManager;

//Login

- (void)request_CaptchaNeededWithPath:(NSString *)path
                             andBlock:(void (^) (id data, NSError *error))block;

- (void)request_Login_WithParams:(id)params
                        andBlock:(void (^)(id data, NSError *error))block;

//Image
- (void)loadImageWithPath:(NSString *)imageUrlStr completeBlock:(void(^)(UIImage *image, NSError *error))block;

//Project
- (void)request_Projects_WithObj:(Projects *)projects andBlock:(void (^)(Projects *data, NSError *error))block;
- (void)request_Project_Pin:(Project *)project andBlock:(void (^)(id data, NSError *error))block;

//Tweet
- (void)request_Tweets_WithObj:(Tweets *)tweets andBlock:(void (^)(id data, NSError *error))block;
- (void)request_Tweet_DoLike_WithObj:(Tweet *)tweet andBlock:(void (^)(id data, NSError *error))block;


//Topic
- (void)request_BannersWithBlock:(void (^)(id data, NSError *error))block;
@end
