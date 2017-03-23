//
//  LXFirstViewController.m
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import "LXFirstViewController.h"
#import "LXScollTitleView.h"
#import "LXScrollContentView.h"
#import "LXTestViewController.h"

@interface LXFirstViewController ()

@property (nonatomic, strong) LXScollTitleView *titleView;

@property (nonatomic, strong) LXScrollContentView *contentView;

@end

@implementation LXFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self reloadData];
}

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

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 35);
    self.contentView.frame = CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height - 35);
}


@end
