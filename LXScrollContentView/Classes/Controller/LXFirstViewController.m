//
//  LXFirstViewController.m
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import "LXFirstViewController.h"
#import "LXScollTitleView.h"

@interface LXFirstViewController ()

@property (nonatomic, strong) LXScollTitleView *titleView;

@end

@implementation LXFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    self.titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    [self.view addSubview:self.titleView];
    [self.titleView reloadViewWithTitles:@[@"体育",@"经济",@"文化",@"NBA",@"楼市",@"房产"]];    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.titleView.frame = CGRectMake(0, 100, self.view.frame.size.width, 50);
}


@end
