//
//  ProjectMember.m
//  Coding
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ProjectMember.h"

@implementation ProjectMember
+ (ProjectMember *)member_All{
    ProjectMember *mem = [[ProjectMember alloc] init];
    mem.user_id = [NSNumber numberWithInteger:-1];
    mem.user = nil;
    return mem;
}
- (NSString *)toQuitPath{
    return [NSString stringWithFormat:@"api/project/%d/quit", _project_id.intValue];
}
- (NSString *)toKickoutPath{
    return [NSString stringWithFormat:@"api/project/%@/kickout/%@", _project_id.stringValue, _user_id.stringValue];
}

@end
