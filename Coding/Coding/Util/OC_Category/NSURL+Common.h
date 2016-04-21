//
//  NSURL+Common.h
//  Coding
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Common)
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
- (NSDictionary *)queryParams;
@end
