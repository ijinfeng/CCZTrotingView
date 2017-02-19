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
//    label.rate = CCZTrotingRateFast;
    label.direction = CCZTrotDirectionTop;
    [self.view addSubview:label];
    self.trotView = label;
    label.repeatTextArr = YES;
    label.hideWhenStopTroting = YES;
    label.pause = 2;
    label.backgroundImage = [UIImage imageNamed:@"1"];
    
    // 添加滚动文本
    [label addTextArray:@[@"恭喜xxx获得森气",@"今晚9点我们不见不散",@"今日的风儿甚是喧嚣",@"iOS开发真是屌",@"xxxxx我爱你！！！"]];
    
    
    UIImageView *head = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headr.jpg"]];
    head.frame = CGRectMake(0, 0, 30, 30);
    label.leftView = head;
    
    
    
    /// 按钮控制
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    [button1 setTitle:@"添加新文本" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 40)];
    [button2 setTitle:@"删除全部" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(didClickRemoveAll) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 40)];
    [button3 setTitle:@"删除第2个" forState:UIControlStateNormal];
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(didClickRemoveIndex) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickButton {
    [self.trotView addTextArray:@[@"每个人心中都有一颗常青树",@"2017将是我的转折点",@"同志祝你好运"]];
}

- (void)didClickRemoveAll {
    [self.trotView removeAllAttribute];
}

- (void)didClickRemoveIndex {
    [self.trotView removeAttributeAtIndex:2];
}

@end
