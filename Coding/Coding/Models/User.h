//
//  User.h
//  Coding
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (readwrite, nonatomic, strong) NSString *avatar, *name, *global_key, *path, *slogan, *company, *tags_str, *tags, *location, *job_str, *job, *email, *birthday, *pinyinName;

@property (readwrite, nonatomic, strong) NSNumber *id, *sex, *follow, *followed, *fans_count, *follows_count, *tweets_count, *status;

@end
