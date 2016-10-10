//
//  ViewController.m
//  CCZTrotView
//
//  Created by 金峰 on 16/9/22.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import "ViewController.h"

#import "CCZTrotingLabel.h"

@interface ViewController ()
@property (nonatomic, strong) CCZTrotingLabel *trotView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CCZTrotingLabel *label = [[CCZTrotingLabel alloc] init];
    label.frame = CGRectMake(30, 40, 300, 30);
    label.rate = CCZTrotingRateFast;
    [label addText:@"恭喜雷姆玩家获得999朵玫瑰"];
    [self.view addSubview:label];
    self.trotView = label;
    label.hideWhenStopTroting = YES;
    label.pause = 2;
    label.backgroundImage = [UIImage imageNamed:@"1"];
    
    UIImageView *head = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headr.jpg"]];
    head.frame = CGRectMake(0, 0, 30, 30);
    label.leftView = head;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"添加新文本" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 200, 80, 40);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
    
    
//    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headr.jpg"]];
    imageView.frame = CGRectMake(0, 0, 40, 40);
    CCZTrotingView *trotView = [[CCZTrotingView alloc] initWithFrame:CGRectMake(40, 300, 320, 40)];
    trotView.duration = 2.5;
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    left.backgroundColor = [UIColor redColor];
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    right.backgroundColor = [UIColor grayColor];
    trotView.leftView = left;
    trotView.rightView = right;
    trotView.autoTrotingRepeat = YES;
    trotView.pause = 1.5;
    [trotView addTrotView:imageView];

    [self.view addSubview:trotView];
}

- (void)didClickButton {
    
    CCZTrotingAttribute *att = [[CCZTrotingAttribute alloc] init];
    att.text = @"恭喜雷姆玩家获得999朵玫瑰";
    UIColor *color  = [UIColor colorWithRed:arc4random() % 255 / 255. green:arc4random() % 255 / 255. blue:arc4random() % 255 / 255. alpha:1];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:att.text];
    [attr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(2, 2)];

    att.attribute = attr;
    self.trotView.rate = CCZTrotingRateFast;
    [self.trotView addTrotAttribute:att];
}


@end
