//
//  YMPowerDashboard.h
//  CircleAnimationDemo
//
//  Created by dev on 15/12/22.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMPowerDashboard : UIView

/**
 *  line stroke color
 */
@property(strong, nonatomic) UIColor *strokeColor;

/**
 *  title
 */
@property (copy, nonatomic) NSString *title;

/**
 *  subTitle
 */
@property (copy, nonatomic) NSString *subTitle;

/* 
 * animation interval, defalut is 1,unit is second, if not animation ,the interval is invalid;
 */
@property (assign, nonatomic) NSInteger animationInterval;

/**
 *  set percent animated
 *
 *  @param percent  percent
 *  @param animated animated
 */
- (void)setPercent:(CGFloat)percent
          animated:(BOOL)animated;

@end
