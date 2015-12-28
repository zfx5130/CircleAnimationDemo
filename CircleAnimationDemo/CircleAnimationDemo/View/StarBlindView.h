//
//  StarBlindView.h
//  CircleAnimationDemo
//
//  Created by dev on 15/12/25.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarBlindView;
@protocol StarBlindViewDataSource <NSObject>

/**
 *  star the radiuses array, if the array not set, will set all starBlind radius is 4.0f,
 *  if set array, will be arcrandom set radius with the array element.
 *
 *  @param starBlindView
 *
 *  @return radiues, nsnumber type
 */
- (NSArray *)starBlindRadiusesForStarBlindView:(StarBlindView *)starBlindView;

/**
 *  the star blind will be Around the rect nearby, if you set the center rect circle, the arcrandom star will be arcrandom round the center rect circle near. if you not set, default is the view center,UIEdgeInsets(10, 10, 10, 10).
 *
 *  @param starBlindView
 *
 *  @return the center rect
 */
- (CGRect)centerRectForStarBlindView:(StarBlindView *)starBlindView;

/**
 *  the star blind padding ,the star blind will be set near +/- pading with the center rect circle,
    default is +/- 20.0f.
 *
 *  @param starBlindView
 *
 *  @return the center rect padding
 */
- (CGFloat)centerPaddingForStarBlindView:(StarBlindView *)starBlindView;

@end

@interface StarBlindView : UIView

/**
 *  blind star count
 */
@property (assign, nonatomic) NSUInteger count;

/**
 *  dataSource , if set the starBlindViewDateSource method.must be set the dataSource
 */
@property (weak, nonatomic) id <StarBlindViewDataSource> dateSource;

@end
