//
//  Projects.h
//  Coding
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Project.h"

typedef NS_ENUM(NSUInteger, ProjectsType) {
    ProjectsTypeAll = 0,
    ProjectsTypeJoined,
    ProjectsTypeCreated,
    
    ProjectsTypeToChoose,
    
    ProjectsTypeTaProject,
    ProjectsTypeTaStared,

};

@interface Projects : NSObject

@property (strong, nonatomic) User *curUser;
@property (assign, nonatomic) ProjectsType type;
//请求
@property (readwrite, nonatomic, strong) NSNumber *page, *pageSize;
@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;
//解析
@property (readwrite, nonatomic, strong) NSNumber *totalPage, *totalRow;
@property (readwrite, nonatomic, strong) NSMutableArray *list;
@property (strong, nonatomic, readonly) NSArray *pinList, *noPinList;
@property (readwrite, nonatomic, strong) NSDictionary *propertyArrayMap;

+ (Projects *)projectsWithType:(ProjectsType)type andUser:(User *)user;
- (NSDictionary *)toParams;
- (NSString *)toPath;
- (void)configWithProjects:(Projects *)responsePros;

@end
