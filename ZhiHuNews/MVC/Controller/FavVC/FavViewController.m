//
//  FavViewController.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "FavViewController.h"

@interface FavViewController ()

@end

@implementation FavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNaviBar];
}

-(void)setupNaviBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenW - 100) / 2, (64 - 35) / 2, 100, 35)];
    label.text = @"收藏";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
}
@end
