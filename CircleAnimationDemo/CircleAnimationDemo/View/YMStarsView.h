//
//  StarsView.h
//  CircleAnimationDemo
//
//  Created by dev on 15/12/25.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMStarsView;
@protocol StarsViewDataSource <NSObject>

/**
 *  will return the default value if unset, the default stars radius is 4.0f,
 *  if set array, will be arcrandom set radius with the array element.
 *
 *  @param starsView
 *
 *  @return radiues
 */
- (NSArray<NSNumber *> *)starRadiusesForStarsView:(YMStarsView *)starsView;

/**
 *  will return the default value if unset, default stars count is 20.
 *
 *  @param starsView starsView
 *
 *  @return star count
 */
- (NSUInteger)starCountForStarsView:(YMStarsView *)starsView;

@end

@protocol StarsViewDelegate <NSObject>

/**
 *  the stars will be Around the rect nearby, if you set the center rect, the arcrandom star will be arcrandom round the center rect near. if you not set, default is the view center,UIEdgeInsets(10, 10, 10, 10).
 *
 *  @param starsView
 *
 *  @return the center rect
 */
- (CGRect)centerRectForStarsView:(YMStarsView *)starsView;

/**
 *  the stars padding ,the stars will be set near +/- padding with the center rect circle,
    default is +/- 20.0f.Horizontal
 *
 *  @param starsView
 *
 *  @return the centerX padding
 */
- (CGFloat)horizontalPaddingForStarsView:(YMStarsView *)starsView;

/**
 *  the stars padding y ,the stars will be set near +/- padding with the center rect,Vertical
 *
 *  @param starsView starsView
 *
 *  @return the centerY padding
 */
- (CGFloat)verticalPaddingForStarsView:(YMStarsView *)starsView;

@end

@interface YMStarsView : UIView

/**
 *  dataSource , if set the starsViewDateSource method, must be set the dataSource
 */
@property (weak, nonatomic) id <StarsViewDataSource> dateSource;

/**
 *  delegate , if set the starsViewDelegate method, must be set the delegate
 */
@property (weak, nonatomic) id <StarsViewDelegate> delegate;

/**
 *  star show
 */
- (void)showStars;

@end
