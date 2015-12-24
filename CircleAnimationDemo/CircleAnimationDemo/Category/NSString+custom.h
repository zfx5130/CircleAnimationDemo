//
//  NSString+custom.h
//  CircleAnimationDemo
//
//  Created by dev on 15/12/24.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (custom)

- (NSAttributedString *)attributedString:(NSDictionary *)attributes
                                 forText:(NSString *)text;

@end
