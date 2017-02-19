# CCZTrotingView
走马灯视图，图文排布，动态视图，让信息提示更彰显华丽
===
*属性／方法介绍：
===
首先进入 CCZTrotingView.h 文件，这个是基类文件，一切d自定义在这里开始。
```Objective-C
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
---> 上面这两个属性大家可以看成是UITextView中的leftView一样，其实用法就是一样的，创建好视图w给它赋值即可。
    ...
    UIImageView *head = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headr.jpg"]];
    head.frame = CGRectMake(0, 0, 30, 30);
    label.leftView = head;
    ...
@property (nonatomic, strong) UIView *trotContaierView;
---> 这个属性是滚动视图的容器视图，也就是说假如你设置了leftView或者rightView的话，那么这座有两个View其实不是在trotContaierView上的，相应的trotContaierView的宽度也是减掉了座有视图的宽度的。
```

接下来说说最重要的几个方法
---
```Objective-C
/**
 添加需要滚动的view
 */
- (void)addTrotView:(UIView *)trotView;
---> 这个是最主要的方法

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
    
我们在将视图添加上去的时候就开始了动画，但是又有个问题就是得知道此时界面上是否已经存在在滚动的动画，假如有了，那么我们得缓存起来。判断的条件就是下面这个属性：
@property (nonatomic, assign) BOOL isTroting;   /**< 是否在滚动*/

/**
 停止troting
 */
- (void)trotingStop:(void(^)())stopBlock;
---> 这个其实是在开始动画的时候就回调一次，下面类同。

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
```
*关于如何自定义
===
```
不妨先看看有关这个类的实现 CCZTrotingLabel，它就是继承于CCZTrotingView来实现富文本走马灯label 的。
这样子类化使用的好处是，我们只需要创建一个滚动视图实例，剩下的就是复用➕d改变内容即可。
这里重要的有一个属性就是，复用需要得到当前的滚动视图，在CCZTrotingView中有个属性：
@property (nonatomic, strong) UIView *currentTrotView;  /**< 当前正在滚动的view*/
以及做到适当时机刷新即可：
/**
 主动去执行troting，会重置正在进行的troting
 */
- (void)updateTroting;
```
具体请大家看Demo的使用方法。
