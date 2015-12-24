//
//  UILabel+custom.m
//  CircleAnimationDemo
//
//  Created by dev on 15/12/24.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import "UILabel+custom.h"
#import "NSString+custom.h"

@implementation UILabel (custom)

- (void)addAttributes:(NSDictionary *)attributes
              forText:(NSString *)text {
    NSAttributedString *attributedString =
    [self.text attributedString:attributes
                        forText:text];
    self.attributedText = attributedString;
}
@end
