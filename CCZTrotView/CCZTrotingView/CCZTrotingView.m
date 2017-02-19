//
//  CCZTrotingView.m
//  CCZTrotView
//
//  Created by 金峰 on 16/9/22.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import "CCZTrotingView.h"

typedef void(^CCZTrotingBlock)();
@interface CCZTrotingView ()<CAAnimationDelegate>
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) CAKeyframeAnimation *trotingXAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *trotingYAnimation;
@property (nonatomic, strong) NSMutableArray *trotViewArr;  /**< 用于存放待滚动的view的*/
@property (nonatomic, copy)   CCZTrotingBlock stopBlock;
@property (nonatomic, copy)   CCZTrotingBlock startBlock;
@property (nonatomic, copy)   CCZTrotingBlock trotingBlock;
@end

@implementation CCZTrotingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __basicSetting];
        [self __pageSetting];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self __basicSetting];
        [self __pageSetting];
    }
    return self;
}

- (void)__basicSetting {
    self.backgroundColor = [UIColor whiteColor];
    _direction = CCZTrotDirectionLeft; // 从最右侧滚入，左侧滑出
    _duration = 10;
    _pause = 0.0;
    _autoTrotingRepeat = NO;
    _isTroting = NO;
    _hideWhenStopTroting = NO;
    _trotViewArr = [NSMutableArray arrayWithCapacity:1];
}

- (void)__pageSetting {
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:_backgroundImageView];
    
    _trotContaierView = [[UIView alloc] init];
    _trotContaierView.clipsToBounds = YES;
    [self addSubview:_trotContaierView];
}

- (void)layoutSubviews {
    _size = self.frame.size;
    _backgroundImageView.frame = self.bounds;
    
    if (self.leftView) {
        CGSize leftSize = self.leftView.frame.size;
        self.leftView.frame = CGRectMake(0, (_size.height - leftSize.height) / 2, leftSize.width, leftSize.height);
    }
    
    if (self.rightView) {
        CGSize rightSize = self.rightView.frame.size;
        self.rightView.frame = CGRectMake(_size.width - rightSize.width, (_size.height - rightSize.height) / 2, rightSize.width, rightSize.height);
    }
    
    self.trotContaierView.frame = CGRectMake(CGRectGetMaxX(self.leftView.frame), 0, _size.width - CGRectGetWidth(self.leftView.frame) - CGRectGetWidth(self.rightView.frame), _size.height);
    
    // initialize trot frame
    CGSize trotContainerSize = self.trotContaierView.frame.size;
    UIView *trotView = [self.trotViewArr firstObject];
    self.currentTrotView = trotView;
    CGSize trotSize = trotView.frame.size;
    if (!trotView) {
        return;
    }
    self.hidden = NO;
    _isTroting = YES;
    
    if (self.trotingBlock) {
        self.trotingBlock();
    }
    
    if (_direction == CCZTrotDirectionLeft) {
        trotView.frame = CGRectMake(trotContainerSize.width, (_size.height - trotSize.height) / 2, trotSize.width, trotSize.height);
        
        CGFloat l = (trotContainerSize.width + trotSize.width);
        CGFloat v = l / _duration;
        self.trotingXAnimation.values = @[@(0), @(- trotContainerSize.width), @(- trotContainerSize.width), @(- l)];
        self.trotingXAnimation.keyTimes = @[@0, @(trotContainerSize.width / v / (_duration + _pause)), @(_pause / (_duration + _pause)  + trotContainerSize.width / v / (_duration + _pause)), @(1)];
        
    } else if (_direction == CCZTrotDirectionRight) {
        trotView.frame = CGRectMake(- trotSize.width, (_size.height - trotSize.height) / 2, trotSize.width, trotSize.height);
        
        CGFloat l = (trotContainerSize.width + trotSize.width);
        CGFloat v = l / _duration;
        self.trotingXAnimation.values = @[@(0), @(trotContainerSize.width), @(trotContainerSize.width), @(l)];
        self.trotingXAnimation.keyTimes = @[@0, @(trotContainerSize.width / v / (_duration + _pause)), @(_pause / (_duration + _pause)  + trotContainerSize.width / v / (_duration + _pause)), @(1)];
        
    } else if (_direction == CCZTrotDirectionTop) {
        trotView.frame = CGRectMake(0, trotContainerSize.height, trotSize.width, trotSize.height);
        
        CGFloat l = (trotContainerSize.height + trotSize.height);
        CGFloat v = l / _duration;
        self.trotingYAnimation.values = @[@(0), @(- ((trotContainerSize.height - trotSize.height) / 2 + trotSize.height)), @(- ((trotContainerSize.height - trotSize.height) / 2 + trotSize.height)), @(- l)];
        self.trotingYAnimation.keyTimes = @[@0, @(trotContainerSize.height / v / (_duration + _pause)), @(_pause / (_duration + _pause)  + trotContainerSize.height / v / (_duration + _pause)), @(1)];
        
    } else {
        trotView.frame = CGRectMake(0, - trotSize.height, trotSize.width, trotSize.height);
        
        CGFloat l = (trotContainerSize.height + trotSize.height);
        CGFloat v = l / _duration;
        self.trotingYAnimation.values = @[@(0), @((trotContainerSize.height - trotSize.height) / 2 + trotSize.height), @((trotContainerSize.height - trotSize.height) / 2 + trotSize.height), @(l)];
        self.trotingYAnimation.keyTimes = @[@0, @(trotContainerSize.height / v / (_duration + _pause)), @(_pause / (_duration + _pause)  + trotContainerSize.height / v / (_duration + _pause)), @(1)];
    }
    
    if ([trotView.layer animationForKey:@"trotingX"]) {
        [trotView.layer removeAnimationForKey:@"trotingX"];
    }
    if ([trotView.layer animationForKey:@"trotingY"]) {
        [trotView.layer removeAnimationForKey:@"trotingY"];
    }
    
    if (_direction == CCZTrotDirectionLeft || _direction == CCZTrotDirectionRight) {
        self.trotingXAnimation.removedOnCompletion = _autoTrotingRepeat;
        self.trotingXAnimation.repeatCount = _autoTrotingRepeat? CGFLOAT_MAX : 0;
        [trotView.layer addAnimation:self.trotingXAnimation forKey:@"trotingX"];
    } else {
        self.trotingYAnimation.removedOnCompletion = _autoTrotingRepeat;
        self.trotingYAnimation.repeatCount = _autoTrotingRepeat? CGFLOAT_MAX : 0;
        [trotView.layer addAnimation:self.trotingYAnimation forKey:@"trotingY"];
    }

}

- (CAKeyframeAnimation *)trotingXAnimation {
    if (!_trotingXAnimation) {
        _trotingXAnimation = [CAKeyframeAnimation animation];
        _trotingXAnimation.keyPath = @"transform.translation.x";
        _trotingXAnimation.delegate = self;
        _trotingXAnimation.duration = _duration;
        _trotingXAnimation.fillMode = kCAFillModeForwards;
        _trotingXAnimation.removedOnCompletion = NO;
    }
    return _trotingXAnimation;
}

- (CAKeyframeAnimation *)trotingYAnimation {
    if (!_trotingYAnimation) {
        _trotingYAnimation = [CAKeyframeAnimation animation];
        _trotingYAnimation.keyPath = @"transform.translation.y";
        _trotingYAnimation.delegate = self;
        _trotingYAnimation.duration = _duration;
        _trotingYAnimation.fillMode = kCAFillModeForwards;
        _trotingYAnimation.removedOnCompletion = NO;
    }
    return _trotingYAnimation;
}

#pragma mark - public

- (void)addTrotView:(UIView *)trotView {
    if (self.currentTrotView) {
        [self.trotViewArr removeObject:self.trotViewArr.firstObject];
        [self.currentTrotView removeFromSuperview];
    }
    
    [self.trotViewArr addObject:trotView];
    [self.trotContaierView addSubview:trotView];
    
    if (!_isTroting) {
        [self setNeedsLayout];
    }
}

- (void)trotingStop:(void (^)())stopBlock {
    if (stopBlock) {
        self.stopBlock = stopBlock;
    }
}

- (void)trotingStart:(void (^)())startBlcok {
    if (startBlcok) {
        self.startBlock = startBlcok;
    }
}

- (void)troting:(void (^)())trotingBlock {
    if (trotingBlock) {
        self.trotingBlock = trotingBlock;
    }
}

- (void)updateTroting {
    [self setNeedsLayout];
}

#pragma mark - Set

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    
    self.backgroundImageView.image = backgroundImage;
}

- (void)setLeftView:(UIView *)leftView {
    _leftView = leftView;
    
    [self addSubview:leftView];
}

- (void)setRightView:(UIView *)rightView {
    _rightView = rightView;
    
    [self addSubview:_rightView];
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    
    self.trotingXAnimation.duration = duration;
}

- (void)setHideWhenStopTroting:(BOOL)hideWhenStopTroting {
    _hideWhenStopTroting = hideWhenStopTroting;
    self.hidden = hideWhenStopTroting;
}

#pragma mark - Animation delegate

- (void)animationDidStart:(CAAnimation *)anim {
    
    if (self.startBlock) {
        self.startBlock();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _isTroting = NO;
    self.hidden = self.hideWhenStopTroting;
    
    if (self.stopBlock) {
        self.stopBlock();
    }
}

@end
