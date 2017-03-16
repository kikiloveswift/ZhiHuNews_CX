//
//  HomeScrollViewController.m
//  ZhiHuNews
//
//  Created by kong on 17/3/15.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeScrollViewController.h"

@interface HomeScrollViewController ()

@property (nonatomic, strong) NSMutableSet *pages;

@end

@implementation HomeScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView contentoffset x is %.1f",scrollView.contentOffset.x);
}

@end
