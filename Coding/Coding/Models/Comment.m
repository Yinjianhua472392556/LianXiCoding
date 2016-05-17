//
//  Comment.m
//  Coding
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (void)setContent:(NSString *)content {
    if (_content != content) {
        _htmlMedia = [HtmlMedia htmlMediaWithString:content showType:MediaShowTypeAll];
        _content = _htmlMedia.contentDisplay;
    }
}

@end
