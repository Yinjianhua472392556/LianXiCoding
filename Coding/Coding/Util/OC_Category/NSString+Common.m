//
//  NSString+Common.m
//  Coding
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
#import <RegexKitLite.h>


@implementation NSString (Common)
- (NSString *)md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (NSString*) sha1Str
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


- (NSURL *)urlImageWithCodePathResizeToView:(UIView *)view{
    return [self urlImageWithCodePathResize:2*CGRectGetWidth(view.frame)];
}

- (NSURL *)urlImageWithCodePathResize:(CGFloat)width{
    return [self urlImageWithCodePathResize:width crop:NO];
}


- (NSURL *)urlImageWithCodePathResize:(CGFloat)width crop:(BOOL)needCrop{
    NSString *urlStr;
    BOOL canCrop = NO;
    if (!self || self.length <= 0) {
        return nil;
    }else{
        if (![self hasPrefix:@"http"]) {
            NSString *imageName = [self stringByMatching:@"/static/fruit_avatar/([a-zA-Z0-9\\-._]+)$" capture:1];
            if (imageName && imageName.length > 0) {
                urlStr = [NSString stringWithFormat:@"http://coding-net-avatar.qiniudn.com/%@?imageMogr2/auto-orient/thumbnail/!%.0fx%.0fr", imageName, width, width];
                canCrop = YES;
            }else{
                urlStr = [NSString stringWithFormat:@"%@%@", [NSObject baseURLStr], self];
            }
        }else{
            urlStr = self;
            if ([urlStr rangeOfString:@"qbox.me"].location != NSNotFound) {
                if ([urlStr rangeOfString:@".gif"].location != NSNotFound) {
                    if ([urlStr rangeOfString:@"?"].location != NSNotFound) {
                        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"/thumbnail/!%.0fx%.0fr/format/png", width, width]];
                    }else{
                        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"?imageMogr2/auto-orient/thumbnail/!%.0fx%.0fr/format/png", width, width]];
                    }
                }else{
                    if ([urlStr rangeOfString:@"?"].location != NSNotFound) {
                        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"/thumbnail/!%.0fx%.0fr", width, width]];
                    }else{
                        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"?imageMogr2/auto-orient/thumbnail/!%.0fx%.0fr", width, width]];
                    }
                }
                canCrop = YES;
            }else if ([urlStr rangeOfString:@"www.gravatar.com"].location != NSNotFound){
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"s=[0-9]*" withString:[NSString stringWithFormat:@"s=%.0f", width] options:NSRegularExpressionSearch range:NSMakeRange(0, [urlStr length])];
            }else if ([urlStr hasSuffix:@"/imagePreview"]){
                urlStr = [urlStr stringByAppendingFormat:@"?width=%.0f", width];
            }
        }
        if (needCrop && canCrop) {
            urlStr = [urlStr stringByAppendingFormat:@"/gravity/Center/crop/%.0fx%.0f", width, width];
        }
        return [NSURL URLWithString:urlStr];
    }
}

- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size {

    return [self getSizeWithFont:font constrainedToSize:size].height;
}

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {

    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }

    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        resultSize = [self boundingRectWithSize:size
                                        options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                     attributes:@{NSFontAttributeName: font}
                                        context:nil].size;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        //        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
        //
        //        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        [paragraphStyle setLineSpacing:2.0];
        //
        //        [attributedStr addAttribute:NSParagraphStyleAttributeName
        //                              value:paragraphStyle
        //                              range:NSMakeRange(0, [self length])];
        //        resultSize = [attributedStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
#endif
    }
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    //    if ([self containsEmoji]) {
    //        resultSize.height += 10;
    //    }
    return resultSize;
}


- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size {

    return [self getSizeWithFont:font constrainedToSize:size].width;
}


#pragma mark emotion_monkey

- (NSRange)rangeByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet {

    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (length = [self length]; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return NSMakeRange(location, length - location);
    
}

@end
