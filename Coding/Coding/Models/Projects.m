//
//  Projects.m
//  Coding
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Projects.h"

@implementation Projects

- (instancetype)init {

    self = [super init];
    if (self) {
        _canLoadMore = NO;
        _isLoading = NO;
        _willLoadMore = NO;
        _propertyArrayMap = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Project", @"list", nil];

    }
    return self;
}

+ (Projects *)projectsWithType:(ProjectsType)type andUser:(User *)user {

    Projects *pros = [[Projects alloc] init];
    pros.type = type;
    pros.curUser = user;
    
    pros.page = [NSNumber numberWithInteger:1];
    pros.pageSize = [NSNumber numberWithInteger:9999];
    return pros;
}

- (NSString *)toPath {
    NSString *path;
    if (self.type >= ProjectsTypeTaProject) {
        path = [NSString stringWithFormat:@"api/user/%@/public_projects",_curUser.global_key];
    }else {
    
        path = @"api/projects";
    }
    
    return path;
}

- (NSDictionary *)toParams {

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page" : [NSNumber numberWithInteger:_willLoadMore?   self.page.integerValue + 1 : 1], @"pageSize" : self.pageSize, @"type" : [self typeStr]}];
    if (self.type == ProjectsTypeAll) {
        [params setObject:@"hot" forKey:@"sort"];
    }
    
    return params;
}

- (NSString *)typeStr {
    NSString *typeStr;
    switch (_type) {
        case  ProjectsTypeAll:
        case  ProjectsTypeToChoose:
            typeStr = @"all";
            break;
        case  ProjectsTypeJoined:
            typeStr = @"joined";
            break;
        case  ProjectsTypeCreated:
            typeStr = @"created";
            break;
        case  ProjectsTypeTaProject:
            typeStr = @"project";
            break;
        case  ProjectsTypeTaStared:
            typeStr = @"stared";
            break;
        default:
            typeStr = @"all";
            break;
    }
    return typeStr;
}

- (void)configWithProjects:(Projects *)responsePros {

    self.page = responsePros.page;
    self.totalRow = responsePros.totalRow;
    self.totalPage = responsePros.totalPage;
    self.canLoadMore = (self.page.integerValue < self.totalPage.integerValue);
    
    NSArray *projectList = responsePros.list;
    if (self.type == ProjectsTypeToChoose) {
        projectList = [projectList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_public == %d", NO]];
    }
    
    if (projectList.count <= 0) {
        return;
    }
    
    if (_willLoadMore) {
        [self.list addObjectsFromArray:projectList];
    }else {
        self.list = [NSMutableArray arrayWithArray:projectList];
    }
}

- (NSArray *)pinList{
    NSArray *list = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pin.intValue == 1"];
    list = [self.list filteredArrayUsingPredicate:predicate];
    return list;
}
- (NSArray *)noPinList{
    NSArray *list = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pin.intValue == 0"];
    list = [self.list filteredArrayUsingPredicate:predicate];
    return list;
}


@end
