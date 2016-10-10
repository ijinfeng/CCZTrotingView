//
//  CCZTrotingView.h
//  CCZTrotView
//
//  Created by 金峰 on 16/9/22.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CCZTrotDirection) {
    CCZTrotDirectionTop,
    CCZTrotDirectionBottom,
    CCZTrotDirectionLeft,   /**< Default*/
    CCZTrotDirectionRight,
};

@interface CCZTrotingView : UIView
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIView *currentTrotView;  /**< 当前正在滚动的view*/
@property (nonatomic, strong) UIView *trotContaierView;
@property (nonatomic, assign) CCZTrotDirection direction;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval pause; /**< 在主页暂停的时间, default is 0*/
@property (nonatomic, assign) BOOL autoTrotingRepeat;    /**< Default is NO, auto repeat*/
@property (nonatomic, assign) BOOL isTroting;   /**< 是否在滚动*/
@property (nonatomic, assign) BOOL hideWhenStopTroting; /**< 在滚动完成之后隐藏, default is NO*/

/**
 添加需要滚动的view
 */
- (void)addTrotView:(UIView *)trotView;
/**
 停止troting
 */
- (void)trotingStop:(void(^)())stopBlock;
/**
 开始troting
 */
- (void)trotingStart:(void(^)())startBlcok;
/**
 正在troting
 */
- (void)troting:(void(^)())trotingBlock;
/**
 主动去执行troting，会重置正在进行的troting
 */
- (void)updateTroting;
@end



