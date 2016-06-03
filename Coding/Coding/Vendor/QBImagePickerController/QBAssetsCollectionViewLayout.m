//
//  QBAssetsCollectionViewLayout.m
//  Coding
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QBAssetsCollectionViewLayout.h"

@implementation QBAssetsCollectionViewLayout
+ (instancetype)layout {

    return [[self alloc] init];
}

- (instancetype)init {

    self = [super init];
    if (self) {
        self.minimumLineSpacing = 2.0;
        self.minimumInteritemSpacing = 2.0;
    }
    return self;
}
@end
