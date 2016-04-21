//
//  ProjectMember.h
//  Coding
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface ProjectMember : NSObject
@property (readwrite, nonatomic, strong) NSNumber *id, *project_id, *user_id, *type, *done, *processing;//type:80是member，100是creater
@property (readwrite, nonatomic, strong) User *user;
@property (readwrite, nonatomic, strong) NSDate *created_at, *last_visit_at;
+ (ProjectMember *)member_All;
- (NSString *)toQuitPath;
- (NSString *)toKickoutPath;

@end
