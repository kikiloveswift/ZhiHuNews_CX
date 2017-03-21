//
//  HomeRootViewController.m
//  ZhiHuNews
//
//  Created by kong on 17/3/17.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeRootViewController.h"
#import "HomeRootViewController+AF.h"
#import "HomeScrollViewController.h"

#import "HomeModel_Theme.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"

#define kListBarH 30
#define kArrowW 40
#define kAnimationTime 0.3

@interface HomeRootViewController ()<ItemSelected,HomeScrollViewControllerDelegate>


@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;

@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic, strong) HomeScrollViewController *homeScrollVC;

@end

@implementation HomeRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNaviBar];
    [self requestAFTheme];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void)setupNaviBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenW - 100) / 2, (64 - 35) / 2, 100, 35)];
    label.text = @"最强资讯";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
}

- (void)requestAFTheme
{
    [self requestThemeAPI:^(id obj) {
        if (obj && [[obj objectForKey:@"others"] isKindOfClass:[NSArray class]])
        {
            NSArray *others = (NSArray *)[obj objectForKey:@"others"];
            if (others.count > 0)
            {
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic  in others)
                {
                    HomeModel_Theme *model = [[HomeModel_Theme alloc] initContentWithDic:dic];
                    [mArr addObject: model];
                }
                self.themeArr = mArr;
                [self makeContent];
            }
        }
        else
        {
            //断网提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"断网提示" message:@"当前断网" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }];
}

-(void)makeContent
{
    NSMutableArray *listTop = [NSMutableArray array];
    NSMutableArray *listBottom = [NSMutableArray array];
    [listTop addObject:@"首页"];
    for (HomeModel_Theme *model in _themeArr)
    {
        if (listTop.count < 6)
        {
            if ([model.name isEqualToString:@"用户推荐日报"])
            {
                [listTop addObject:@"用户推荐"];
            }
            else
            {
                [listTop addObject:model.name];
            }
        }
        else
        {
            if ([model.name isEqualToString:@"用户推荐日报"])
            {
                [listBottom addObject:@"用户推荐"];
            }
            else
            {
                [listBottom addObject:model.name];
            }
        }
    }
    
    __weak typeof(self) unself = self;
    
    if (!self.detailsList) {
        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH, kScreenW, kScreenH-kListBarH-64)];
        self.detailsList.listAll = [NSMutableArray arrayWithObjects:listTop,listBottom, nil];
        self.detailsList.longPressedBlock = ^(){
            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
        };
        self.detailsList.opertionFromItemBlock = ^(animateType type, NSString *itemName, int index){
            [unself.listBar operationFromBlock:type itemName:itemName index:index];
        };
        [self.view addSubview:self.detailsList];
    }
    
    if (!self.listBar) {
        self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kListBarH)];
        self.listBar.visibleItemList = listTop;
        self.listBar.itemDelegate = self;
        self.listBar.arrowChange = ^(){
            if (unself.arrow.arrowBtnClick) {
                unself.arrow.arrowBtnClick();
            }
        };
        self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
            [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
            //添加scrollview
        };
        [self.view addSubview:self.listBar];
    }
    
    if (!self.deleteBar) {
        self.deleteBar = [[BYDeleteBar alloc] initWithFrame:self.listBar.frame];
        [self.view addSubview:self.deleteBar];
    }
    
    
    if (!self.arrow) {
        self.arrow = [[BYArrow alloc] initWithFrame:CGRectMake(kScreenW-kArrowW, 0, kArrowW, kListBarH)];
        self.arrow.arrowBtnClick = ^(){
            unself.deleteBar.hidden = !unself.deleteBar.hidden;
            [UIView animateWithDuration:kAnimationTime animations:^{
                CGAffineTransform rotation = unself.arrow.imageView.transform;
                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                unself.detailsList.transform = (unself.detailsList.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenH):CGAffineTransformMakeTranslation(0, -kScreenH);
            }];
        };
        [self.view addSubview:self.arrow];
    }
    if (!self.homeScrollVC)
    {
        HomeScrollViewController *scrollVC = [[HomeScrollViewController alloc] init];
        scrollVC.themeCount = self.themeArr.count;
        [self addChildViewController:scrollVC];
        scrollVC.view.frame = self.view.bounds;
        scrollVC.controllDelegate = self;
        [self.view insertSubview:scrollVC.view belowSubview:self.detailsList];
        self.homeScrollVC = scrollVC;
        scrollVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
}

#pragma Mark-HomeScrollViewControllerDelegate
- (void)homePageDidScroll:(UIScrollView *)scrollView
{
    [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / kScreenW];
}

#pragma Mark-ItemSelected
- (void)itemClickWith: (NSString *)btnTitle
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
