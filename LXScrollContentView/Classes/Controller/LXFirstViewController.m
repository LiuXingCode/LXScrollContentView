//
//  LXFirstViewController.m
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import "LXFirstViewController.h"
#import "LXScrollContentView.h"
#import "LXTestViewController.h"
#import "LXSegmentTitleView.h"

@interface LXFirstViewController () <LXSegmentTitleViewDelegate, LXScrollContentViewDelegate>

@property (nonatomic, strong) LXSegmentTitleView *titleView;

@property (nonatomic, strong) LXScrollContentView *contentView;

@end

#pragma mark -
@implementation LXFirstViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 35);
    self.contentView.frame = CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height - 35);
}


#pragma mark - UI

- (void)setupUI {
    self.titleView = [[LXSegmentTitleView alloc] initWithFrame:CGRectZero];
    self.titleView.itemMinMargin = 15.f;
    self.titleView.delegate = self;
    self.titleView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:self.titleView];
    
    self.contentView = [[LXScrollContentView alloc] initWithFrame:CGRectZero];
    self.contentView.delegate = self;
    [self.view addSubview:self.contentView];
}


#pragma mark - Event

- (void)reloadData {
    NSArray *titles = @[@"首页", @"体育在线", @"科技日报", @"生活", @"本地", @"精彩视频", @"娱乐", @"时尚", @"房地产", @"经济"];
    self.titleView.segmentTitles = titles;
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (NSString *title in titles) {
        LXTestViewController *vc = [[LXTestViewController alloc] init];
        vc.category = title;
        [vcs addObject:vc];
    }
    [self.contentView reloadViewWithChildVcs:vcs parentVC:self];
    self.titleView.selectedIndex = 2;
    self.contentView.currentIndex = 2;
}


#pragma mark - LXSegmentTitleViewDelegate

- (void)segmentTitleView:(LXSegmentTitleView *)segmentView
           selectedIndex:(NSInteger)selectedIndex
       lastSelectedIndex:(NSInteger)lastSelectedIndex
{
    self.contentView.currentIndex = selectedIndex;
}


#pragma mark - LXScrollContentViewDelegate

- (void)contentViewDidScroll:(LXScrollContentView *)contentView
                   fromIndex:(NSInteger)fromIndex
                     toIndex:(NSInteger)toIndex
                    progress:(float)progress
{
    self.titleView.selectedIndex = toIndex;
}

- (void)contentViewDidEndDecelerating:(LXScrollContentView *)contentView
                           startIndex:(NSInteger)startIndex
                             endIndex:(NSInteger)endIndex
{
    self.titleView.selectedIndex = endIndex;
}

@end
