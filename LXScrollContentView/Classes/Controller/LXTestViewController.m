//
//  LXTestViewController.m
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import "LXTestViewController.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@interface LXTestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LXTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad -- %ld", self.index);
    
    [self setupUI];
}

- (void)setupUI {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.text = [NSString stringWithFormat:@"%@ %ld", self.category, self.index];
    headerLabel.font = [UIFont boldSystemFontOfSize:40.f];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.tableView.tableHeaderView = headerLabel;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear -- %ld", self.index);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear -- %ld", self.index);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 第%ld行",self.category,(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
