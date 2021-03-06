//
//  ViewController.m
//  CircleAnimationDemo
//
//  Created by dev on 15/12/22.
//  Copyright © 2015年 thomas. All rights reserved.
//

#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#import "ViewController.h"
#import "YMPowerDashboard.h"
#import "YMStarsView.h"

#import <Masonry.h>

@interface ViewController ()
<StarsViewDataSource,
StarsViewDelegate>

@property (strong, nonatomic) YMPowerDashboard *circleAnimationView;

@property (strong, nonatomic) UIImageView *bgimageView;

@property (strong, nonatomic) UIImageView *otherbgImageView;

@property (strong, nonatomic) YMStarsView *starsView;

@property (strong, nonatomic) CADisplayLink *displayLink;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:2.0f delay:0.0f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        self.otherbgImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.otherbgImageView.alpha = 1.0f;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    
    self.title = @"Demo";
    
    //star
    self.starsView = [[YMStarsView alloc] init];
    self.starsView.delegate = self;
    self.starsView.dateSource = self;
    [self.view addSubview:self.starsView];
    [self.starsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.starsView.superview);
        make.top.equalTo(self.starsView.superview).with.offset(64.0f);
    }];
    [self.starsView showStars];
    
    
    CGFloat defaultValue = 1.0f;
    CGRect frame = CGRectMake((SCREEN_WIDTH - 260.0f) * 0.5f, 80.0f, 260.0f, 260.0f);
    self.circleAnimationView = [[YMPowerDashboard alloc] initWithFrame:frame];
    self.circleAnimationView.animationInterval = 1.5f;
    self.circleAnimationView.strokeColor = [UIColor whiteColor];
    [self.circleAnimationView setPercent:defaultValue
                                animated:YES];
    self.circleAnimationView.title = @"剩余电量";
    self.circleAnimationView.subTitle = [NSString stringWithFormat:@"可行驶%.1fkm",0.6 * 55];
    [self.view addSubview:self.circleAnimationView];
    [self.circleAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(260.0f);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(130.0f);
    }];
    
    //slider
    UISlider *slider = [[UISlider alloc] init];
    slider.continuous = NO;
    slider.minimumTrackTintColor = [UIColor whiteColor];
    [slider addTarget:self
               action:@selector(setStrokeEndValue:)
     forControlEvents:UIControlEventValueChanged];
    slider.value = defaultValue;
    [self.view addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(slider.superview).with.offset(-20.0f);
        make.bottom.equalTo(slider.superview).with.offset(-20.0f);
        make.centerX.equalTo(slider.superview);
    }];
}

#pragma mark - StarsViewDelegate

- (CGRect)centerRectForStarsView:(YMStarsView *)starsView {
    return CGRectMake((SCREEN_WIDTH - 260.0f) * 0.5f, 0.0f, 260.0f, 260.0f);
}

- (CGFloat)verticalPaddingForStarsView:(YMStarsView *)starsView {
    return 10.0f;
}

- (CGFloat)horizontalPaddingForStarsView:(YMStarsView *)starsView {
    return 10.0f;
}

#pragma mark - StarsViewDataSource

- (NSArray<NSNumber *> *)starRadiusesForStarsView:(YMStarsView *)starsView {
    return @[@4, @5, @6, @2];
}

- (NSUInteger)starCountForStarsView:(YMStarsView *)starsView {
    return 15;
}

#pragma mark - Handlers

- (void)setStrokeEndValue:(UISlider *)sender {
    [self.circleAnimationView setPercent:sender.value
                                animated:YES];
    self.circleAnimationView.subTitle =
    [NSString stringWithFormat:@"可行驶%.1fkm",sender.value * 55];
}

@end
