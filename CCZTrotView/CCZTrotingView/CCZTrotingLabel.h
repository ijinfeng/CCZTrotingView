//
//  CCZTrotingLabel.h
//  CCZTrotView
//
//  Created by 金峰 on 16/9/25.
//  Copyright © 2016年 金峰. All rights reserved.
//

/// 使用时只需要用这个封装好的 CCZTrotingLabel就可以了

#import "CCZTrotingView.h"
#import "CCZTrotingAttribute.h"

typedef NS_ENUM(NSUInteger, CCZTrotingRate) {
    CCZTrotingRateFast,
    CCZTrotingRateNormal,   /**< Default*/
    CCZTrotingRateSlow,
};
@interface CCZTrotingLabel : CCZTrotingView
@property (nonatomic, assign) CCZTrotingRate rate;
@property (nonatomic, strong, readonly) UILabel *currentLabel;
@property (nonatomic, assign) BOOL repeatTextArr; // 重复滚动数组，默认NO

- (void)addText:(NSString *)text;
- (void)addTrotAttribute:(CCZTrotingAttribute *)attribute;
- (void)addTextArray:(NSArray *)textArray;
- (void)addAttributeArray:(NSArray *)attArray;

- (void)removeAttributeAtIndex:(NSUInteger)index;
- (void)removeAllAttribute;
@end
