//
//  Tweet.h
//  Coding
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject


+(Tweet *)tweetForSend;
- (void)saveSendData;

@end
