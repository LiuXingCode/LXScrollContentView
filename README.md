# LXScrollContentView

高仿网易新闻客户端左右滑动切换页面的框架

github链接：https://github.com/LiuXingCode/LXScrollContentView

简书链接：http://www.jianshu.com/p/4ca324102e10

## 1. LXScrollContentView描述

这是一个高仿网易新闻客户端首页滑动切换页面的框架。支持点击上方标题，切换下方内容页面，也支持滑动下方内容区域，切换上方的标题。

![点击上方标题下方页面切换](http://omwe26vh5.bkt.clouddn.com/17-3-27/70023878-file_1490598698656_8e31.gif)


![滑动切换内容页面上方标题跟随切换](http://omwe26vh5.bkt.clouddn.com/17-3-27/65255846-file_1490598698820_c511.gif)

## 2.安装方法

LXScrollContentView支持CocoaPods安装

```
pod 'LXScrollContentView'
```

也可以下载示例Demo,把里面的LXScrollContentViewLib文件夹拖到你的项目中即可

## 3.API使用说明

本框架有 **LXScollTitleView** 和 **LXScrollContentView** 两个类，它们完全独立，可以根据项目需求选择使用。

**LXScollTitleView**表示上方标题区域，它的具体使用方法如下：

```
/**
 文字未选中颜色，默认black
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 文字选中和下方滚动条颜色，默认red
 */
@property (nonatomic, strong) UIColor *selectedColor;


/**
 第几个标题处于选中状态，默认为0
 */
@property (nonatomic, assign) NSInteger selectedIndex;


/**
 每个标题宽度,默认85.f
 */
@property (nonatomic, assign) CGFloat titleWidth;


/**
 标题字体font，默认14.f
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 下方滚动指示条高度，默认2.f
 */
@property (nonatomic, assign) CGFloat indicatorHeight;

/**
 选中标题回调block
 */
@property (nonatomic, copy) BMPageTitleViewSelectedBlock selectedBlock;


/**
 刷新界面

 @param titles 标题数组
 */
- (void)reloadViewWithTitles:(NSArray *)titles;
```

**LXScrollContentView** 表示下方滚动内容区域，它的具体使用方法如下：

```
/**
 设置当前滚动到第几个页面，默认为0
 */
@property (nonatomic, assign) NSInteger currentIndex;


/**
 页面滚动停止时触发block回调
 */
@property (nonatomic, copy) LXScrollContentViewBlock scrollBlock;


/**
 刷新页面内容

 @param childVcs 当前View需要装入的控制器集合
 @param parentVC 当前View所在的父控制器
 */
- (void)reloadViewWithChildVcs:(NSArray<UIViewController *> *)childVcs parentVC:(UIViewController *)parentVC;
```

以下是一个在ViewController中具体使用案例

```
//初始化UI
- (void)setupUI{
    self.titleView = [[LXScollTitleView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    self.titleView.selectedBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        strongSelf.contentView.currentIndex = index;
    };
    self.titleView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.titleView.titleWidth = 60.f;
    [self.view addSubview:self.titleView];
    
    self.contentView = [[LXScrollContentView alloc] initWithFrame:CGRectZero];
    self.contentView.scrollBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        strongSelf.titleView.selectedIndex = index;
    };
    [self.view addSubview:self.contentView];
}

//调整titleView和contentView的frame
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 35);
    self.contentView.frame = CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height - 35);
}

//刷新titleView和contentView的数据源，根据项目需求自行选择数据源
- (void)reloadData{
    NSArray *titles = @[@"首页",@"体育",@"科技",@"生活",@"本地",@"视频",@"娱乐",@"时尚",@"房地产",@"经济"];
    [self.titleView reloadViewWithTitles:titles];
    
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (NSString *title in titles) {
        LXTestViewController *vc = [[LXTestViewController alloc] init];
        vc.category = title;
        [vcs addObject:vc];
    }
    [self.contentView reloadViewWithChildVcs:vcs parentVC:self];
}
```

## 4.期望

1.这是 **LXScrollContentView** 框架发布的第一个版本，还有很多不完善的地方，欢迎大家提出bug。

2.**LXScollTitleView** 暂时只有一种样式，我会尽快增加更多样式。

3.LXScrollContentView目前使用UICollectionView滑动，在性能方面已经比较优秀。接下来考虑加入cache功能，争取达到更加顺滑的效果。

4.大家如果觉得本框架不错，希望你们可以 **Star** 一下，我会更有动力的去不断完善。

5.我的邮箱账号：**liuxinghenau@163.com** ，简书地址：**http://www.jianshu.com/u/f367c6621844** ，大家有问题可以随时联系。
