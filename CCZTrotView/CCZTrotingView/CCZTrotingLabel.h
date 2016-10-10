//
//  CCZTrotingLabel.h
//  CCZTrotView
//
//  Created by 金峰 on 16/9/25.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import "CCZTrotingView.h"
#import "CCZTrotingAttribute.h"

typedef NS_ENUM(NSUInteger, CCZTrotingRate) {
    CCZTrotingRateFast = 1,
    CCZTrotingRateNormal,   /**< Default*/
    CCZTrotingRateSlow,
};
@interface CCZTrotingLabel : CCZTrotingView
@property (nonatomic, assign) CCZTrotingRate rate;
@property (nonatomic, strong) UILabel *currentLabel;

- (void)addText:(NSString *)text;
- (void)addTrotAttribute:(CCZTrotingAttribute *)attribute;
@end
