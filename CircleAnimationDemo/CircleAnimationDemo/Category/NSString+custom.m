//
//  NSString+custom.m
//  CircleAnimationDemo
//
//  Created by dev on 15/12/24.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import "NSString+custom.h"

@implementation NSString (custom)

- (NSAttributedString *)attributedString:(NSDictionary *)attributes
                                 forText:(NSString *)text {
    if (!self.length) {
        return nil;
    }
    NSString *rangeText = [text isKindOfClass:[NSString class]] ?
    text : [NSString stringWithFormat:@"%@", text];
    NSRange range = [self rangeOfString:rangeText];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:self];
    for (NSString *attributeKey in attributes) {
        [attributedString addAttribute:attributeKey
                                 value:attributes[attributeKey]
                                 range:range];
    }
    
    return attributedString;
}

@end
