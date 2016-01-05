//
//  CricleAnimationView.m
//  CircleAnimationDemo
//
//  Created by dev on 15/12/22.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import "YMPowerDashboard.h"

#import "UILabel+custom.h"

#import <POP.h>
#import <Masonry.h>

static NSString *const kDefaultUnitLabelText = @"%";

static const CGFloat kDefaultCircleWidth = 4.0f;
static const CGFloat kDefaultCircleCount = 60.0f;
static const CGFloat kDefalutUnitLabelFontSize = 16.0f;
static const CGFloat kDefalutTitleLabelFontSize = 16.0f;
static const CGFloat kDefalutBatteryLabelFontSize = 80.0f;
static const CGFloat kDefalutSubTitleLabelFontSize = 16.0f;

@interface YMPowerDashboard ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CAReplicatorLayer *replicatorOtherLayer;
@property (strong, nonatomic) CADisplayLink *displayLink;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *batteryLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UILabel *unitLabel;
@property (strong, nonatomic) UIView *circleView;
@property (assign, nonatomic) CGFloat startValue;
@property (assign, nonatomic) CGFloat endValue;
@property (assign, nonatomic) CGFloat currentValue;
@property (assign, nonatomic) CFTimeInterval beginTime;

@end

@implementation YMPowerDashboard

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addWhiteReplicatorLayer];
        [self addAlphaReplicatorLayer];
        [self setupViews];
    }
    return self;
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.subTitleLabel.text = subTitle;
}

- (void)setCurrentValue:(CGFloat)currentValue {
    _currentValue = currentValue;
    self.batteryLabel.text = [NSString stringWithFormat:@"%d", (int)(currentValue * 100)];
    [self setNeedsDisplay];
}

#pragma mark - Getters

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(updatePower)];
    }
    return _displayLink;
}

#pragma mark - Private

- (void)addWhiteReplicatorLayer {
    [self addReplicatorLayerWith:self.replicatorLayer
                     circleCount:kDefaultCircleCount
                           alpha:0.6f
                        duration:3.0f];
}

- (void)addAlphaReplicatorLayer {
    [self addReplicatorLayerWith:self.replicatorOtherLayer
                     circleCount:kDefaultCircleCount * 2
                           alpha:0.2f
                        duration:3.0f];
}

- (void)addReplicatorLayerWith:(CAReplicatorLayer *)replicatorLayer
                   circleCount:(NSUInteger)circleCount
                         alpha:(CGFloat)alpha
                      duration:(CGFloat)duration {
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
    basicAnimation.fromValue = @1.1;
    basicAnimation.toValue = @0.6;
    basicAnimation.duration = duration;
    basicAnimation.repeatCount = HUGE;
    basicAnimation.autoreverses = YES;
    [circle addAnimation:basicAnimation
                  forKey:nil];
}

- (void)setupViews {
    self.animationInterval = 1.0f;
    self.backgroundColor = [UIColor clearColor];
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
    CGFloat width = sqrt(pow(CGRectGetWidth(self.frame) * 0.5f - 30.0f, 2) - pow(CGRectGetHeight(self.batteryLabel.frame) * 0.5, 2)) * 2.0f;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel.superview);
        make.width.lessThanOrEqualTo(@(width));
        make.height.mas_equalTo(@35);
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
        make.centerY.equalTo(self.titleLabel.superview);
        make.height.mas_equalTo(60.0f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.width.lessThanOrEqualTo(self.titleLabel.mas_width);
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
        make.width.equalTo(self.titleLabel.mas_width);
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
        make.left.equalTo(self.batteryLabel.mas_right).offset(-3);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
}

- (void)startDisplayLink {
    [self stopDisplayLink];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
    self.displayLink.paused = NO;
    self.beginTime = CACurrentMediaTime();
}

- (void)updatePower {
    CGFloat percent = (CACurrentMediaTime() - self.beginTime) / self.animationInterval / fabs(self.endValue
     - self.startValue);
    percent = percent > 1 ? 1.0f : percent;
    percent = percent < 0 ? 0.0f : percent;
    self.currentValue = self.startValue + (self.endValue - self.startValue) * percent;
    if (self.currentValue == self.endValue) {
        self.startValue = self.endValue;
        [self stopDisplayLink];
    }
}

- (void)stopDisplayLink {
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - Public 

- (void)setPercent:(CGFloat)percent
          animated:(BOOL)animated {
    self.endValue = percent;
    if (animated) {
        [self startDisplayLink];
    } else {
        self.currentValue = percent;
        self.startValue = self.endValue;
    }
}

/*
- (void)setStrokeEnd:(CGFloat)strokeEnd
            animated:(BOOL)animated {
    if (animated) {
        [self animateToStrokeEnd:strokeEnd];
    } else {
        self.circleLayer.strokeEnd = strokeEnd;
        self.innerCircleLayer.strokeEnd = strokeEnd;
    }
    self.batteryLabel.text = [NSString stringWithFormat:@"%d", (int)(strokeEnd * 100)];
    [self addHandleCircleAnimationWithStrokeEnd:strokeEnd];
    [self setNeedsDisplay];
}
*/

#pragma mark - Lifecycle

- (void)drawRect:(CGRect)rect {
    
    /****************方法2,画细线和线头的圆(少渐变色) ***/
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat centerX = width * 0.5f;
    CGFloat centerY = height * 0.5f;
    CGFloat lineWidth = 4.0f;
    CGFloat radius = width * 0.5f - lineWidth * 0.5f;
    CGFloat innerRadius = radius - 10.0f;
    //int scaleCount = 60;
    CGContextRef context = UIGraphicsGetCurrentContext();
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
    
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextSetLineWidth(context, 4);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGMutablePathRef pathM = CGPathCreateMutable();
    CGPathAddArc(pathM, NULL, centerX, centerY, radius, 3 * M_PI / 2, 3 * M_PI / 2 + 2 * M_PI * self.currentValue, NO);
    CGContextAddPath(context, pathM);
    CGContextStrokePath(context);

    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, self.currentValue);
    CGContextSetLineWidth(context, 1);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGMutablePathRef pathMain = CGPathCreateMutable();
    CGPathAddArc(pathMain, NULL, centerX, centerY, innerRadius, 3 * M_PI / 2, 3 * M_PI / 2 + 2 * M_PI * self.currentValue, NO);
    CGContextAddPath(context, pathMain);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, 255.0f / 255.0f, 255.0f / 255.0f, 255.0f / 255.0, 1.0f);
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, self.currentValue);
    CGContextTranslateCTM(context, centerX, centerY);
    CGContextSaveGState(context);
    CGContextRotateCTM(context, 2 * M_PI * self.currentValue);
    CGContextStrokeEllipseInRect(context, CGRectMake(0.0f, - innerRadius - 2, 4, 4));
    CGContextRestoreGState(context);

}

@end
