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
    //上拉加载存储时间
    NSString *_recommand_date_more;
    
    //下拉刷新存储时间
    NSString *_recommand_date_refresh;
    
    //其他Channel
    //上拉加载存储参数
    NSString *_channel_last_params;
    
    //下拉刷新存储参数
    NSString *_channel_first_params;
}


@property (nonatomic, strong) HomeModel_Theme *currentSelectedModel;


@property (nonatomic, strong) NSMutableArray *mArr1;

@property (nonatomic, strong) NSMutableArray *mArr2;

@property (nonatomic, strong) NSMutableArray *mArr3;


/**
 目前正在显示的tableView
 */
@property (nonatomic, strong) UITableView *showTableView;


/**
 当前频道
 */
@property (nonatomic, strong) NSNumber *currentChannel;


@property (nonatomic, strong) HomeScrollViewController *scrollVC;


@end

@implementation HomeListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (instancetype)initWithChannel:(NSNumber *)channel
{
    self = [super init];
    if (self)
    {
        _currentChannel = channel;
        [self settings];
        [self addUI];
        if (channel.integerValue == 1)
        {
            [self requestRecommandAPINEWS:nil WithState:0 Theme:[NSString stringWithFormat:@"%@",channel]];

        }
        else
        {
            [self requestChannelAPINEWS:nil WithState:0 Theme:[NSString stringWithFormat:@"%@",channel]];
        }
        
    }
    return self;
}
- (void)settings
{
    if (!_mArr1)
    {
        _mArr1 = [NSMutableArray array];
    }
    
    _currentSelectedModel = [HomeModel_Theme new];
    _currentSelectedModel.name = @"首页";
    _recommand_date_refresh = @"";
    _recommand_date_more = @"";
    _channel_last_params = @"";
    _channel_first_params = @"";
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
    _mTableView.mj_footer = [BaseMJAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _mTableView.mj_header = [BaseMJAutoHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];

}

//下拉刷新
- (void)pullToRefresh
{
    if (_currentChannel.integerValue == 1)
    {
        [self requestRecommandAPINEWS:nil WithState:0 Theme:@"1"];
    }
    else
    {
        //刷新别的页面
        [self requestChannelAPINEWS:nil WithState:0 Theme:[NSString stringWithFormat:@"%@",_currentChannel]];
    }
    
}

//上拉加载
- (void)loadMoreData
{
    if (_currentChannel.integerValue == 1)
    {
        if (![_recommand_date_more isEqualToString:@""])
        {
            [self requestRecommandAPINEWS:_recommand_date_more WithState:1 Theme:@"1"];
        }
    }
    else
    {
        [self requestChannelAPINEWS:_channel_last_params WithState:1 Theme:[NSString stringWithFormat:@"%@",_currentChannel]];
    }
}

//请求首页接口 0为下拉刷新 1为上拉加载
- (void)requestRecommandAPINEWS:(NSString *)params WithState:(NSInteger)state Theme:(NSString *)theme
{
    [self requestRecommandAPI:^(id obj)
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            if ([obj objectForKey:@"date"])
            {
                _recommand_date_more = [obj objectForKey:@"date"];
                
                if (state == 0)
                {
                    if (_recommand_date_refresh.length > 0)
                    {
                        if ([_recommand_date_refresh isEqualToString:[obj objectForKey:@"date"]])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_mTableView reloadData];
                                [_mTableView.mj_header endRefreshing];
                            });
                            return;
                        }
                        else
                        {
                            _recommand_date_refresh = [obj objectForKey:@"date"];
                        }
                    }
                    else
                    {
                        _recommand_date_refresh = [obj objectForKey:@"date"];
                    }
                }
                
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
                if (state)
                {
                    [_mTableView.mj_footer endRefreshing];
                }
                else
                {
                    [_mTableView.mj_header endRefreshing];
                }
            }
        }
        else
        {
            if (state)
            {
                [_mTableView.mj_footer endRefreshing];
            }
            else
            {
                [_mTableView.mj_header endRefreshing];
            }
        }
    } Params:params Theme:theme];
}

- (void)requestChannelAPINEWS:(NSString *)params WithState:(NSInteger)state Theme:(NSString *)theme
{
    [self requestRecommandAPI:^(id obj)
     {
         if ([obj isKindOfClass:[NSDictionary class]])
         {
             if ([[obj objectForKey:@"stories"] isKindOfClass:[NSArray class]])
             {
                 NSArray *stories = (NSArray *)[obj objectForKey:@"stories"];
                 NSMutableArray *mArr = [NSMutableArray array];
                 for (NSDictionary *dic in stories)
                 {
                     HomeModel_NewsList *list = [[HomeModel_NewsList alloc] initContentWithDic:dic];
                     [mArr addObject:list];
                 }
                 HomeModel_NewsList *lFModel = (HomeModel_NewsList *)[mArr firstObject];
                 if (_channel_first_params.integerValue == lFModel.id_n.integerValue)
                 {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [_mTableView reloadData];
                             [_mTableView.mj_header endRefreshing];
                         });
                         return;
                 }
                 else
                 {
                     _channel_first_params = [NSString stringWithFormat:@"%@",lFModel.id_n];
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
                 HomeModel_NewsList *lModel = (HomeModel_NewsList *)[self.dataArrMiddle lastObject];
                 _channel_last_params = [NSString stringWithFormat:@"%@",lModel.id_n];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.mTableView reloadData];
                 });
                 if (state)
                 {
                     [_mTableView.mj_footer endRefreshing];
                 }
                 else
                 {
                     [_mTableView.mj_header endRefreshing];
                 }
             }
         }
         else
         {
             if (state)
             {
                 [_mTableView.mj_footer endRefreshing];
             }
             else
             {
                 [_mTableView.mj_header endRefreshing];
             }
         }
     } Params:params Theme:theme];
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
