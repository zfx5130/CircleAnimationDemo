//
//  StarsView.m
//  CircleAnimationDemo
//
//  Created by dev on 15/12/25.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import "StarsView.h"
#import <Masonry.h>

static const NSUInteger kDefaultStarCount = 20;
static const CGFloat kDefalutCollectionViewItemSize = 4.0f;
static const CGFloat kDefaultCenterPadding = 20.0f;
static const CGFloat kDefalutCenterEdgeInsetsPadding = 10.0f;
static NSString *const kResueIdentifierStarsCollectionViewCell =
    @"kResueIdentifierStarsCollectionViewCell";

@interface StarsCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGPoint center;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) CGFloat cellCount;
@property (copy, nonatomic) NSArray *starRadiuses;
@property (assign, nonatomic) CGRect centerRect;
@property (assign, nonatomic) CGFloat centerPadding;

@end

@implementation StarsCollectionViewFlowLayout

-(void)prepareLayout {
    [super prepareLayout];
    
    CGRect rect = [self centerRect];
    self.cellCount = [[self collectionView] numberOfItemsInSection:0];
    self.center = CGPointMake(rect.origin.x + rect.size.width * 0.5f,
                              rect.origin.y + 40 + rect.size.height * 0.5f);
    self.radius = MIN(rect.size.width * 0.5f,
                      rect.size.height * 0.5f);
}

-(CGSize)collectionViewContentSize {
    return [self collectionView].frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    UICollectionViewLayoutAttributes* attributes =
    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    CGFloat centerX = 0.0f;
    CGFloat centerY = 0.0f;
    CGFloat valueX = ((double)arc4random() / 0x100000000) * self.centerPadding;
    CGFloat valueY = ((double)arc4random() / 0x100000000) * self.centerPadding;
    if (path.item <= self.cellCount / 4) {
        centerX = valueX;
        centerY = centerY;
    } else if (path.item <= self.cellCount / 2) {
        centerX = -valueX;
        centerY = valueY;
    } else if (path.item <= (self.cellCount * 3 / 4)) {
        centerX = -valueX;
        centerY = -valueY;
    } else if (path.item <= self.cellCount) {
        centerX = valueX;
        centerY = -valueY;
    }
    NSInteger y = path.item;
    if ([self.starRadiuses count]) {
        if (y > [self.starRadiuses count] - 1) {
            y = y % [self.starRadiuses count];
        }
    } else {
        y = kDefalutCollectionViewItemSize;
    }
    attributes.size = CGSizeMake([self.starRadiuses[y] integerValue],
                                 [self.starRadiuses[y] integerValue]);
    attributes.alpha = ((double)arc4random() / 0x100000000);
    attributes.center = CGPointMake(self.center.x + centerX + self.radius * cosf(2 * path.item * M_PI / self.cellCount),
                                    self.center.y + centerY + self.radius * sinf(2 * path.item * M_PI / self.cellCount));
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i = 0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i
                                                     inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

@end


@interface StarsCollectionViewCell : UICollectionViewCell

@end

@implementation StarsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.contentView.layer.cornerRadius = CGRectGetWidth(self.contentView.frame) * 0.5f;
        self.contentView.layer.masksToBounds = YES;
        CGFloat duration = ((double)arc4random() / 0x100000000) + 1;
        [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionAutoreverse |UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
            self.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        } completion:nil];
    }
    return self;
}

@end


@interface StarsView ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) StarsCollectionViewFlowLayout *starsCollectionViewFlowLayout;

@end

@implementation StarsView

#pragma mark -Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Public

- (void)starsShow {
    [self addStarsView];
}

#pragma mark - Pirvate

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithRed:39.0f / 255.0f
                                           green:183.0f / 255.0f
                                            blue:247.0f / 255.0f
                                           alpha:1.0f];
}

- (void)addStarsView {
    self.starsCollectionViewFlowLayout = [[StarsCollectionViewFlowLayout alloc] init];
    self.starsCollectionViewFlowLayout.centerRect = [self centerRect];
    self.starsCollectionViewFlowLayout.centerPadding = [self centerPadding];
    self.starsCollectionViewFlowLayout.starRadiuses = [self starRadiuses];
    CGRect frame = CGRectZero;
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:self.starsCollectionViewFlowLayout];
    self.collectionView.backgroundColor = [UIColor redColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.superview);
    }];
    [self.collectionView registerClass:[StarsCollectionViewCell class]
            forCellWithReuseIdentifier:kResueIdentifierStarsCollectionViewCell];
}

- (NSUInteger)starCount {
    if ([self.dateSource respondsToSelector:@selector(starCountForStarsView:)]) {
        return [self.dateSource starCountForStarsView:self];
    }
    return kDefaultStarCount;
}

- (NSArray<NSNumber *> *)starRadiuses {
    if ([self.dateSource respondsToSelector:@selector(starRadiusesForStarsView:)]) {
        return [self.dateSource starRadiusesForStarsView:self];
    }
    return nil;
}

- (CGRect)centerRect {
    if ([self.delegate respondsToSelector:@selector(centerRectForStarsView:)]) {
        return [self.delegate centerRectForStarsView:self];
    }
    return CGRectMake(kDefalutCenterEdgeInsetsPadding,
                      kDefalutCenterEdgeInsetsPadding,
                      CGRectGetWidth(self.frame) - kDefalutCenterEdgeInsetsPadding * 2,
                      CGRectGetHeight(self.frame) - kDefalutCenterEdgeInsetsPadding * 2);
}

- (CGFloat)centerPadding {
    if ([self.delegate respondsToSelector:@selector(centerPaddingForStarsView:)]) {
        return [self.delegate centerPaddingForStarsView:self];
    }
    return kDefaultCenterPadding;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self starCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StarsCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kResueIdentifierStarsCollectionViewCell
                                              forIndexPath:indexPath];
    return cell;
}

@end
