//
//  CCZTrotingLabel.m
//  CCZTrotView
//
//  Created by 金峰 on 16/9/25.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import "CCZTrotingLabel.h"

@interface CCZTrotingLabel ()
@property (nonatomic, strong, readwrite) UILabel *currentLabel;
@property (nonatomic, strong) NSMutableArray *attributeArr;
@property (nonatomic, assign) CGFloat normalRate;
@property (nonatomic, assign) NSUInteger index; // 控制滚动的文本显示
@end

@implementation CCZTrotingLabel

- (NSMutableArray *)attributeArr {
    if (!_attributeArr) {
        _attributeArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _attributeArr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self basicSetting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self basicSetting];
    }
    return self;
}

- (void)basicSetting {
    self.rate = CCZTrotingRateNormal;
    self.index = 0;
    self.repeatTextArr = NO;
    
    __weak typeof(self) weakSelf = self;
    [self trotingStop:^{
        if (weakSelf.attributeArr.count) {
            if (weakSelf.repeatTextArr == YES) {
                weakSelf.index == weakSelf.attributeArr.count - 1? weakSelf.index = 0 : weakSelf.index++;
            } else {
                [weakSelf.attributeArr removeObject:weakSelf.attributeArr.firstObject];
            }

            if (weakSelf.attributeArr.count != 0) {
                [weakSelf addTrotAttribute:nil];
            }
        }
    }];
}

#pragma mark - add att

- (void)addTrotAttribute:(CCZTrotingAttribute *)attribute {
    if (attribute) {
        [self.attributeArr addObject:attribute];
    }
    
    CCZTrotingAttribute *trotingAtt = self.attributeArr[self.index];
    
    if (!_currentLabel) {
        _currentLabel = [[UILabel alloc] init];
        [self trotingWithAttribute:trotingAtt];
        [self addTrotView:_currentLabel];
    } else {
        if (!self.isTroting) {
            [self trotingWithAttribute:trotingAtt];
            [self updateTroting];
        }
    }
}

- (void)addText:(NSString *)text {
    CCZTrotingAttribute *trotingAtt = [[CCZTrotingAttribute alloc] init];
    trotingAtt.text = text;
    [self addTrotAttribute:trotingAtt];
}

- (void)addTextArray:(NSArray *)textArray {
    for (id text in textArray) {
        if ([text isKindOfClass:[NSString class]]) {
            [self addText:text];
        }
    }
}

- (void)addAttributeArray:(NSArray *)attArray {
    for (id att in attArray) {
        if ([att isKindOfClass:[CCZTrotingAttribute class]]) {
            [self addTrotAttribute:att];
        }
    }
}

- (void)trotingWithAttribute:(CCZTrotingAttribute *)att {
    _currentLabel.text = att.text;
    if (att.attribute) {
        _currentLabel.attributedText = att.attribute;
    }
    CGSize textSize = [att.text sizeWithAttributes:@{NSFontAttributeName: _currentLabel.font}];
    _currentLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    
    __weak typeof(self) weakSelf = self;
    [self troting:^{
        CGSize trotContrinerSize = weakSelf.trotContaierView.frame.size;
        if (weakSelf.direction == CCZTrotDirectionLeft || weakSelf.direction == CCZTrotDirectionRight) {
            weakSelf.duration = (trotContrinerSize.width + textSize.width) / _normalRate;
        } else {
            weakSelf.duration = (trotContrinerSize.height + textSize.height) / _normalRate;
        }
    }];
}

#pragma mark - remove

- (void)removeAttributeAtIndex:(NSUInteger)index {
    if (index <= self.attributeArr.count - 1) {
        [self.attributeArr removeObjectAtIndex:index];
        if (self.index >= index) {
            self.index--;
        }
    }
}

- (void)removeAllAttribute {
    [self.attributeArr removeAllObjects];
    self.index = 0;
}

#pragma mark - set

- (void)setRate:(CCZTrotingRate)rate {
    _rate = rate;
    
    if (rate == CCZTrotingRateNormal) {
        _normalRate = 40;
    } else if(rate == CCZTrotingRateFast) {
        _normalRate = 90;
    } else {
        _normalRate = 10;
    }
}

@end
