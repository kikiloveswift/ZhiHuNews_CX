//
//  HomeListViewController.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeListViewController.h"

#import "HomeListViewController+AF.h"
#import "HomeModel_Theme.h"

#import "HomeListViewController+NewsList.h"
#import "HomeModel_NewsList.h"
#import "HomeScrollViewController.h"



@interface HomeListViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    MJRefreshHeader *_mjHeader;
    
    MJRefreshFooter *_mjFooter;
    
    //首页推荐接口 顶部date
    NSString *_recommand_date;
}


@property (nonatomic, strong) HomeModel_Theme *currentSelectedModel;


@property (nonatomic, strong) NSMutableArray *mArr1;

@property (nonatomic, strong) NSMutableArray *mArr2;

@property (nonatomic, strong) NSMutableArray *mArr3;


/**
 目前正在显示的tableView
 */
@property (nonatomic, strong) UITableView *showTableView;


@property (nonatomic, strong) HomeScrollViewController *scrollVC;


@end

@implementation HomeListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self settings];
    
    [self addUI];
    
    [self requestRecommandAPINEWS:nil];
    
}

- (void)settings
{
    if (!_mArr1)
    {
        _mArr1 = [NSMutableArray array];
    }
    
    _currentSelectedModel = [HomeModel_Theme new];
    _currentSelectedModel.name = @"首页";
}



- (void)testAF
{
    //http://news-at.zhihu.com/api/4/theme/13
    [AFRequest requestDataWithUrlString:@"http://news-at.zhihu.com/api/4/theme/13" Parameters:nil Method:@"GET" Proxy:nil Success:^(id result) {
        NSLog(@"result is %@",result);
    } Progress:nil Failure:^(id result) {
        
    }];
    
}


//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView == _mainScroller)
//    {
//        [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / self.mainScroller.frame.size.width];
//    }
//}

//TODO: 添加主页视图
- (void)addUI
{
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 94 - 49) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
//    _mTableView.userInteractionEnabled = NO;
    _mTableView.backgroundColor = UIColorHEX(0xDFDFDF, 1);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
    imgView.image = [UIImage imageNamed:@"wallpaper_profile"];
    [_mTableView.backgroundView addSubview:imgView];
    [_mTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    //设置默认分割线为无
    [_mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mTableView];
//    _mTableView.mj_footer = [BaseMJAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
    _mTableView.mj_header = [BaseMJAutoHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];

}

- (void)pullToRefresh
{
    if ([_currentSelectedModel.name isEqualToString:@"首页"])
    {
        [self requestRecommandAPINEWS:nil];
    }
    else
    {
        //刷新别的页面
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [_mTableView.mj_header endRefreshing];
    });
}

- (void)loadMoreData
{
    if ([_currentSelectedModel.name isEqualToString:@"首页"])
    {
        [self requestRecommandAPINEWS:_recommand_date];
    }
    else
    {
        
    }
}

//请求首页接口
- (void)requestRecommandAPINEWS:(NSString *)params
{
    [self requestRecommandAPI:^(id obj)
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            if ([obj objectForKey:@"date"])
            {
                _recommand_date = [obj objectForKey:@"date"];
            }
            if ([[obj objectForKey:@"stories"] isKindOfClass:[NSArray class]])
            {
                NSArray *stories = (NSArray *)[obj objectForKey:@"stories"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in stories)
                {
                    HomeModel_NewsList *list = [[HomeModel_NewsList alloc] initContentWithDic:dic];
                    [mArr addObject:list];
                }
                if (params)
                {
                    [_mArr1 addObjectsFromArray:mArr];
                }
                else
                {
                    [mArr addObjectsFromArray:_mArr1];
                    NSMutableArray *mArrSam = [mArr mutableCopy];
                    [_mArr1 addObjectsFromArray:mArrSam];
                }
                //把数据赋值给数据源
                self.dataArrMiddle = _mArr1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mTableView reloadData];
                });
            }
        }
        else
        {
            
        }
    } Params:params];
}


//点击每个栏目的代理方法
#pragma Mark-ItemSelected
- (void)itemClickWith:(NSString *)btnTitle
{
    HomeModel_Theme *s_model = nil;
    for (HomeModel_Theme *model in _themeArr)
    {
        if ([model.name isEqualToString:btnTitle])
        {
            s_model = model;
            break;
        }
    }
    if ([btnTitle isEqualToString:@"首页"])
    {
        s_model = [HomeModel_Theme new];
        s_model.name = @"首页";
    }
    _currentSelectedModel = s_model;
    //TODO: 请求网络
    [self requestEveryDetailTheme:[NSString stringWithFormat:@"%@",s_model.id_n] Data:^(id obj)
    {
        //TODO: loading
        if ([[obj objectForKey:@"stories"] isKindOfClass:[NSArray class]])
        {
            NSArray *stories = (NSArray *)[obj objectForKey:@"stories"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in stories)
            {
                HomeModel_NewsList *list = [[HomeModel_NewsList alloc] initContentWithDic:dic];
                [mArr addObject:list];
            }
           
            [mArr addObjectsFromArray:_mArr1];
            NSMutableArray *mArrSam = [mArr mutableCopy];
            [_mArr1 addObjectsFromArray:mArrSam];
            
            //把数据赋值给数据源
            self.dataArrMiddle = _mArr1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.showTableView reloadData];
            });
        }

    } Params:nil];
}

#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self n_tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self n_tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self n_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView.y is %.1f",scrollView.contentOffset.y);
}





@end
