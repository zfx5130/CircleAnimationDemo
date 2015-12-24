//
//  CricleAnimationView.m
//  CircleAnimationDemo
//
//  Created by dev on 15/12/22.
//  Copyright © 2015年 thomas. All rights reserved.
//



#import "CircleAnimationView.h"

#import "UILabel+custom.h"

#import <POP.h>
#import <Masonry.h>

static NSString *const kDefaultUnitLabelText = @"%";

static const CGFloat kDefaultCircleWidth = 4.0f;
static const CGFloat kDefaultCircleCount = 60.0f;
static const CGFloat kDefaultPopSpringBounciness = 6.0f;

static const CGFloat kDefalutUnitLabelFontSize = 16.0f;
static const CGFloat kDefalutTitleLabelFontSize = 16.0f;
static const CGFloat kDefalutBatteryLabelFontSize = 80.0f;
static const CGFloat kDefalutSubTitleLabelFontSize = 16.0f;

@interface CircleAnimationView ()

@property (strong, nonatomic) CAShapeLayer *circleLayer;
@property (strong, nonatomic) CAShapeLayer *innerCircleLayer;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CAReplicatorLayer *replicatorOtherLayer;
@property (strong, nonatomic) CALayer *handleCircleLayer;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *batteryLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UILabel *unitLabel;
@property (strong, nonatomic) UIView *circleView;

@end

@implementation CircleAnimationView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addReplicatorLayer];
        [self addReplicatorOtherLayer];
        [self addCircleLayer];
        [self addInnerCircleLayer];
        [self addHandleCircle];
        [self setupViews];
    }
    return self;
}

#pragma mark - Setters

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    self.circleLayer.strokeColor = strokeColor.CGColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setBattery:(NSUInteger)battery {
    _battery = battery;
    self.batteryLabel.text = [NSString stringWithFormat:@"%@", @(battery)];
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.subTitleLabel.text = subTitle;
}

#pragma mark - Private

- (void)addCircleLayer {
    CGFloat lineWidth = kDefaultCircleWidth;
    CGFloat radius = CGRectGetWidth(self.frame) * 0.5f -  lineWidth * 0.5f;
    self.circleLayer = [CAShapeLayer layer];
    CGRect rect = CGRectMake(lineWidth * 0.5f, lineWidth * 0.5f, radius * 2, radius * 2);
    self.circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
    self.circleLayer.strokeColor = self.tintColor.CGColor;
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleLayer.lineWidth = lineWidth;
    self.circleLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.circleLayer];
}

- (void)addInnerCircleLayer {
    CGFloat lineWidth = 1.0f;
    CGFloat padding = 14.0f;
    CGFloat radius = CGRectGetWidth(self.frame) * 0.5f - padding;
    self.innerCircleLayer = [CAShapeLayer layer];
    CGRect rect = CGRectMake(lineWidth * 0.5f + padding - 0.25f, lineWidth * 0.5f + padding - 0.25f, radius * 2, radius * 2);
    self.innerCircleLayer.path =
    [UIBezierPath bezierPathWithRoundedRect:rect
                               cornerRadius:radius].CGPath;
    self.innerCircleLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.innerCircleLayer.fillColor = [UIColor clearColor].CGColor;
    self.innerCircleLayer.lineWidth = lineWidth;
    self.innerCircleLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.innerCircleLayer];

    self.gradientLayer = [CAGradientLayer layer];
    [self.layer addSublayer:self.gradientLayer];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.mask = self.innerCircleLayer;
    [self.layer addSublayer:self.gradientLayer];
    
    CAGradientLayer *rightGradientLayer = [CAGradientLayer layer];
    rightGradientLayer.colors  = @[
                                   (__bridge id)[UIColor colorWithWhite:1.0f
                                                                  alpha:0.0f].CGColor,
                                   (__bridge id)[UIColor colorWithWhite:1.0f
                                                                  alpha:0.3].CGColor,
                                   (__bridge id)[UIColor colorWithWhite:1.0f
                                                                  alpha:0.5f].CGColor
                                   ];
    rightGradientLayer.locations = @[
                                     @(0.0f),
                                     @(0.5f),
                                     @(1.0f)
                                     ];
    rightGradientLayer.startPoint = CGPointMake(0, 0.0f);
    rightGradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
    rightGradientLayer.frame = CGRectMake(self.bounds.size.width * 0.5f,
                                          0,
                                          self.bounds.size.width * 0.5f,
                                          self.bounds.size.height);
    [self.gradientLayer addSublayer:rightGradientLayer];
    
    CAGradientLayer *leftGradientLayer = [CAGradientLayer layer];
    leftGradientLayer.colors  = @[
                                   (__bridge id)[UIColor colorWithWhite:1.0f
                                                                  alpha:0.5f].CGColor,
                                   (__bridge id)[UIColor colorWithWhite:1.0f
                                                                  alpha:0.8].CGColor,
                                   (__bridge id)[UIColor colorWithWhite:1.0f
                                                                  alpha:1.0f].CGColor
                                   ];
    leftGradientLayer.locations = @[
                                     @(0.0f),
                                     @(0.5f),
                                     @(1.0f)
                                     ];
    leftGradientLayer.startPoint = CGPointMake(0, 1.0f);
    leftGradientLayer.endPoint = CGPointMake(0, 0.0f);
    leftGradientLayer.frame = CGRectMake(0.0f,
                                         0.0f,
                                         self.bounds.size.width * 0.5f,
                                         self.bounds.size.height);
    [self.gradientLayer addSublayer:leftGradientLayer];
    
}

- (void)animateToStrokeEnd:(CGFloat)strokeEnd {
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeAnimation.toValue = @(strokeEnd);
    strokeAnimation.springBounciness = kDefaultPopSpringBounciness;
    strokeAnimation.removedOnCompletion = NO;
    [self.circleLayer pop_addAnimation:strokeAnimation
                                forKey:@"layerStrokeAnimation"];
    
    POPSpringAnimation *innerStrokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    innerStrokeAnimation.toValue = @(strokeEnd);
    innerStrokeAnimation.springBounciness = kDefaultPopSpringBounciness;
    innerStrokeAnimation.removedOnCompletion = NO;
    [self.innerCircleLayer pop_addAnimation:innerStrokeAnimation
                                     forKey:@"layerStrokeAnimation"];
}

- (void)addReplicatorLayer {
    [self addReplicatorLayerWith:self.replicatorLayer
                     circleCount:kDefaultCircleCount
                           alpha:0.6f];
}

- (void)addReplicatorOtherLayer {
    [self addReplicatorLayerWith:self.replicatorOtherLayer
                     circleCount:kDefaultCircleCount * 2
                           alpha:0.2f];
}

- (void)addReplicatorLayerWith:(CAReplicatorLayer *)replicatorLayer
                   circleCount:(NSUInteger)circleCount
                         alpha:(CGFloat)alpha {
    replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = self.bounds;
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:replicatorLayer];
    CALayer *circle = [CALayer layer];
    circle.bounds = CGRectMake(0.0f, 0.0f, kDefaultCircleWidth, kDefaultCircleWidth);
    circle.position = CGPointMake(CGRectGetWidth(self.frame) * 0.5f - kDefaultCircleWidth * 0.5f,
                                  kDefaultCircleWidth * 0.5f);
    circle.cornerRadius = kDefaultCircleWidth * 0.5f;
    circle.backgroundColor = [UIColor colorWithWhite:1.0f
                                               alpha:alpha].CGColor;
    [replicatorLayer addSublayer:circle];
    replicatorLayer.instanceCount = circleCount;
    CGFloat angle = (2 * M_PI) / (circleCount);
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    CABasicAnimation *basicAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basicAnimation.fromValue = @1.2;
    basicAnimation.toValue = @0.7;
    basicAnimation.duration = 3.0f;
    basicAnimation.repeatCount = HUGE;
    [circle addAnimation:basicAnimation
                  forKey:nil];
}

- (void)addHandleCircle {
    
    self.circleView = [[UIView alloc] init];
    [self addSubview:self.circleView];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.circleView.backgroundColor = [UIColor clearColor];
    self.handleCircleLayer = [CALayer layer];
    self.handleCircleLayer.bounds = CGRectMake(0.0f, 0.0f, kDefaultCircleWidth, kDefaultCircleWidth);
    self.handleCircleLayer.position =
    CGPointMake(CGRectGetWidth(self.frame) * 0.5f - kDefaultCircleWidth * 0.5f,
                kDefaultCircleWidth * 0.5f + 12.0f);
    self.handleCircleLayer.cornerRadius = kDefaultCircleWidth * 0.5f;
    self.handleCircleLayer.borderColor = [UIColor whiteColor].CGColor;
    self.handleCircleLayer.borderWidth = 1.0f;
    [self.circleView.layer addSublayer:self.handleCircleLayer];
}

- (void)addHandleCircleAnimationWithStrokeEnd:(CGFloat)strokeEnd {
    CGAffineTransform endAngle =
    CGAffineTransformMakeRotation((strokeEnd + 0.0045) * 360 * (M_PI / 180.0f));
    [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.circleView.transform = endAngle;
        self.circleView.alpha = strokeEnd;
    } completion:nil];
}

- (void)setupViews {
    [self setupTitleLabel];
    [self setupBatteryLabel];
    [self setupSubTitleLabel];
    [self setupUnitLabel];
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithWhite:1.0f
                                                  alpha:0.6f];
    self.titleLabel.font = [UIFont systemFontOfSize:kDefalutTitleLabelFontSize];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel.superview);
        make.top.mas_equalTo(70);
        make.size.mas_equalTo(CGSizeMake(100.0f, 35.0f));
    }];
}

- (void)setupBatteryLabel {
    self.batteryLabel = [[UILabel alloc] init];
    self.batteryLabel.font = [UIFont systemFontOfSize:kDefalutBatteryLabelFontSize];
    self.batteryLabel.textAlignment = NSTextAlignmentCenter;
    self.batteryLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.batteryLabel];
    [self.batteryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(60.0f);
        make.width.lessThanOrEqualTo(@150);
    }];
}

- (void)setupSubTitleLabel {
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.textColor = [UIColor colorWithWhite:1.0f
                                                     alpha:0.6f];
    self.subTitleLabel.font = [UIFont systemFontOfSize:kDefalutSubTitleLabelFontSize];
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel);
        make.top.equalTo(self.batteryLabel.mas_bottom);
        make.height.equalTo(self.titleLabel.mas_height);
        make.width.lessThanOrEqualTo(@200);
    }];
}

- (void)setupUnitLabel {
    self.unitLabel = [[UILabel alloc] init];
    self.unitLabel.text = kDefaultUnitLabelText;
    self.unitLabel.textColor = [UIColor whiteColor];
    self.unitLabel.font = [UIFont systemFontOfSize:kDefalutUnitLabelFontSize];
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.unitLabel];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(15.0f);
        make.left.equalTo(self.batteryLabel.mas_right).offset(-5);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
}

#pragma mark - Public 

- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated {
    if (animated) {
        [self animateToStrokeEnd:strokeEnd];
    } else {
        self.circleLayer.strokeEnd = strokeEnd;
        self.innerCircleLayer.strokeEnd = strokeEnd;
    }
    [self addHandleCircleAnimationWithStrokeEnd:strokeEnd];
}

- (void)drawRect:(CGRect)rect {
    
    /****************方法2,画细线和线头的圆(少渐变色) ***/
//    CGFloat width = CGRectGetWidth(rect);
//    CGFloat height = CGRectGetHeight(rect);
//    CGFloat centerX = width * 0.5f;
//    CGFloat centerY = height * 0.5f;
//    CGFloat lineWidth = 4.0f;
//    CGFloat radius = width * 0.5f - lineWidth * 0.5f;
//    CGFloat innerRadius = radius - 10.0f;
//    //int scaleCount = 60;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    for (int i = 0; i < scaleCount; i++) {
//        CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 0.6f);
//        CGContextSetLineWidth(context, lineWidth);
//        CGContextSetLineCap(context, kCGLineCapRound);
//        CGContextSaveGState(context);
//        CGContextTranslateCTM(context, centerX, centerY);
//        CGContextRotateCTM(context, - 2 * M_PI / scaleCount * i);
//        CGPoint line[] = { CGPointMake(0, -radius), CGPointMake(0, -radius) };
//        CGContextStrokeLineSegments(context, line, 2);
//        CGContextRestoreGState(context);
//    }
//    for (int i = 0; i < scaleCount; i++) {
//        CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 0.2f);
//        CGContextSetLineWidth(context, lineWidth);
//        CGContextSetLineCap(context, kCGLineCapRound);
//        CGContextSaveGState(context);
//        CGContextTranslateCTM(context, centerX, centerY);
//        CGContextRotateCTM(context, - 2 * M_PI / scaleCount * (i + 0.5));
//        CGPoint line[] = { CGPointMake(0, -radius), CGPointMake(0, -radius) };
//        CGContextStrokeLineSegments(context, line, 2);
//        CGContextRestoreGState(context);
//    }
//    

//    CGContextBeginPath(context);
//  //  CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 0.3f);
//    CGContextSetLineWidth(context, 1);
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGMutablePathRef pathMain = CGPathCreateMutable();
//    CGPathAddArc(pathMain, NULL, centerX, centerY, innerRadius, 3 * M_PI / 2, 3 * M_PI / 2 + 2 * M_PI * 0.5f, NO);
//    CGContextAddPath(context, pathMain);
//    CGContextStrokePath(context);
//    
//    CGContextBeginPath(context);
//   // CGContextSetRGBFillColor(context, 255.0f / 255.0f, 255.0f / 255.0f, 255.0f / 255.0, 1.0f);
//    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 0.3f);
//    CGContextTranslateCTM(context, centerX, centerY);
//    CGContextSaveGState(context);
//    CGContextRotateCTM(context, 2 * M_PI * 0.5f);
//    CGContextStrokeEllipseInRect(context, CGRectMake(0.0f, - innerRadius - 2, 4, 4));
//    CGContextRestoreGState(context);
    
}

@end
