//
//  StarBlindView.m
//  CircleAnimationDemo
//
//  Created by dev on 15/12/25.
//  Copyright © 2015年 thomas. All rights reserved.
//


#import "StarBlindView.h"
#import <Masonry.h>

static const NSUInteger kDefaultStarBlindViewCount = 60;


@implementation StarBlindView

#pragma mark -Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithRed:39.0f / 255.0f
                                           green:183.0f / 255.0f
                                            blue:247.0f / 255.0f
                                           alpha:1.0f];
    self.count = kDefaultStarBlindViewCount;
}

- (void)starBlindViews {
    for (int i = 0; i < self.count; i++) {
//        UIView *starBlindView = [[UIView alloc] init];
//        CGRect rect = [self centerRect];
//        NSLog(@":::::%@",NSStringFromCGRect(rect));
    }
}

#pragma mark - Pirvate

- (CGRect)centerRect {
    if ([self.dateSource respondsToSelector:@selector(centerRectForStarBlindView:)]) {
        return [self.dateSource centerRectForStarBlindView:self];
    }
    return CGRectMake(10.0f, 10.0f, CGRectGetWidth(self.frame) - 20.0f, CGRectGetHeight(self.frame) - 20.0f);
}

#pragma mark - Setters

- (void)setCount:(NSUInteger)count {
    _count = count;
    [self starBlindViews];
}

#pragma mark - StarBlindViewDataSource

@end
