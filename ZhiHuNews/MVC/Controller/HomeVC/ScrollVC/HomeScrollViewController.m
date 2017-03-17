//
//  HomeScrollViewController.m
//  ZhiHuNews
//
//  Created by kong on 17/3/15.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeScrollViewController.h"
#import "HomeScrollViewController+AF.h"



@interface HomeScrollViewController ()

@property (nonatomic, strong) NSMutableSet *pages;

@property (nonatomic, strong) NSMutableSet *preLoadPages;



@end

@implementation HomeScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setting];
    [self initUI];
    [self preloadPages];
//    [self layoutPages];
}

- (void)setting
{
    if (!_pages)
    {
        _pages = [NSMutableSet set];
    }
    
    if (!_preLoadPages)
    {
        _preLoadPages = [NSMutableSet set];
    }
}

- (void)preloadPages
{
    for (int i = 0; i < 2; i ++)
    {
        [_pages addObject:[HomeListViewController new]];
    }
    for (homePageProtocol vc in _pages)
    {
        vc.scrollDelegate = (id<HomeScrollViewDelegate>)self.parentViewController;
        [self.view addSubview:vc.view];
        [vc.view removeFromSuperview];
        [self addChildViewController:(id)vc];
    }
    for (NSInteger i = 0; i < 2; i ++)
    {
        [self addControllAt:i];
    }
}

- (void)addControllAt:(NSInteger)index
{
    homePageProtocol page = [self recyclePage];
    if (page)
    {
        [self.pages removeObject:page];
    }
    else
    {
        page = [[HomeListViewController alloc] init];
        [self addChildViewController:(id)page];
    }
    [_preLoadPages addObject:page];
    
    page.view.frame = (CGRect){self.scrollView.width * index, 0, self.scrollView.size};
    page.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:page.view];
}

- (homePageProtocol)recyclePage
{
    for (id page in self.pages)
    {
        if ([page isKindOfClass:[HomeListViewController class]])
        {
            return page;
        }
    }
    return nil;
}


- (void)initUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, kScreenW, kScreenH - 49 - 94)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    scrollView.contentSize = CGSizeMake(kScreenW * _themeCount, 0);
//    scrollView.userInteractionEnabled = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView contentoffset x is %.1f",scrollView.contentOffset.x);
}

@end
