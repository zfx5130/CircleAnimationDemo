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
#import "CircleAnimationView.h"
#import <Masonry.h>

@interface ViewController ()

@property (strong, nonatomic) CircleAnimationView *circleAnimationView;

@property (strong, nonatomic) UIImageView *bgimageView;

@property (strong, nonatomic) UIImageView *otherbgImageView;

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
    
    self.bgimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"show_image"]];
    self.otherbgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_image"]];
    [self.view addSubview:self.bgimageView];
    [self.view addSubview:self.otherbgImageView];
    [self.bgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.otherbgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    
    CGRect frame = CGRectMake((SCREEN_WIDTH - 260.0f) * 0.5f, 80.0f, 260.0f, 260.0f);
    self.circleAnimationView = [[CircleAnimationView alloc] initWithFrame:frame];
    self.circleAnimationView.strokeColor = [UIColor whiteColor];
    [self.circleAnimationView setStrokeEnd:0.6
                                  animated:NO];
    self.circleAnimationView.title = @"剩余电量";
    self.circleAnimationView.battery = 60;
    self.circleAnimationView.subTitle = [NSString stringWithFormat:@"可行驶%.1fkm",0.6 * 55];
    [self.view addSubview:self.circleAnimationView];
    [self.circleAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(260.0f);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(130.0f);
    }];
    
//    NSUInteger count = 60;
//    for (int i = 0; i < 60; i++) {
//        UIView *circleView = [[UIView alloc] init];
//        CGFloat left = frame.origin.x + 10.0f;
//        CGFloat top = frame.origin.y + 10.0f;
//        circleView.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, 4.0f, 4.0f);
//        circleView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
//        [self.view addSubview:circleView];
//    }
    
    CGRect sliderFrame = CGRectMake(10.0f, SCREEN_HEIGHT - 40.0f, SCREEN_WIDTH - 20.0f, 20.0f);
    UISlider *slider = [[UISlider alloc] initWithFrame:sliderFrame];
    slider.minimumTrackTintColor = [UIColor whiteColor];
    [slider addTarget:self
               action:@selector(setStrokeEndValue:)
     forControlEvents:UIControlEventValueChanged];
    slider.value = 0.5f;
    [self.view addSubview:slider];
}

#pragma mark - Handlers

- (void)setStrokeEndValue:(UISlider *)sender {
    [self.circleAnimationView setStrokeEnd:sender.value
                                  animated:NO];
    self.circleAnimationView.battery = sender.value * 100;
    self.circleAnimationView.subTitle =
    [NSString stringWithFormat:@"可行驶%.1fkm",sender.value * 55];
}

@end
