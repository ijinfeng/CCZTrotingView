//
//  CCZTrotingLabel.m
//  CCZTrotView
//
//  Created by 金峰 on 16/9/25.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import "CCZTrotingLabel.h"

@interface CCZTrotingLabel ()
@property (nonatomic, strong) NSMutableArray *attributeArr;
@property (nonatomic, assign) CGFloat normalRate;
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

- (void)basicSetting {
    self.rate = CCZTrotingRateNormal;
    
    __weak typeof(self) weakSelf = self;
    [self trotingStop:^{
        if (weakSelf.attributeArr.count) {
            [weakSelf.attributeArr removeObject:weakSelf.attributeArr.firstObject];
            if (weakSelf.attributeArr.count != 0) {
                [weakSelf addTrotAttribute:nil];
            }
        }
    }];
}

- (void)addTrotAttribute:(CCZTrotingAttribute *)attribute {
    if (attribute) {
        [self.attributeArr addObject:attribute];
    }
    
    CCZTrotingAttribute *trotingAtt = self.attributeArr.firstObject;
    
    if (!self.isTroting && _currentLabel) {
        [self trotingWithAttribute:trotingAtt];
        [self updateTroting];
    }
    
    if (!_currentLabel) {
        _currentLabel = [[UILabel alloc] init];
        [self trotingWithAttribute:trotingAtt];
        [self addTrotView:_currentLabel];
    }
}

- (void)addText:(NSString *)text {
    CCZTrotingAttribute *trotingAtt = [[CCZTrotingAttribute alloc] init];
    trotingAtt.text = text;
    [self addTrotAttribute:trotingAtt];
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
