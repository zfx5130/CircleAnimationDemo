//
//  CircleAnimationView.h
//  CircleAnimationDemo
//
//  Created by dev on 15/12/22.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleAnimationView : UIView

/**
 *  line stroke color
 */
@property(strong, nonatomic) UIColor *strokeColor;

/**
 *  title
 */
@property (copy, nonatomic) NSString *title;

/**
 *  battery
 */
@property (assign, nonatomic) NSUInteger battery;

/**
 *  subTitle
 */
@property (copy, nonatomic) NSString *subTitle;

/**
 *  set circle animation with strokeEnd value
 *
 *  @param strokeEnd value
 *  @param animated  animation
 */
- (void)setStrokeEnd:(CGFloat)strokeEnd
            animated:(BOOL)animated;

@end
