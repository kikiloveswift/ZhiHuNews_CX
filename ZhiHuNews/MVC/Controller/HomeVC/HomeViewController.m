//
//  HomeViewController.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeViewController.h"

#import "HomeViewController+AF.h"
#import "HomeModel_Theme.h"

#import "HomeViewController+NewsList.h"
#import "HomeModel_NewsList.h"

#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"

#define kListBarH 30
#define kArrowW 40
#define kAnimationTime 0.3

@interface HomeViewController () <UIScrollViewDelegate, ItemSelected, UITableViewDelegate, UITableViewDataSource, HomeScrollViewDelegate>
{
    MJRefreshHeader *_mjHeader;
    
    MJRefreshFooter *_mjFooter;
    
    //首页推荐接口 顶部date
    NSString *_recommand_date;
}

@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;

@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic,strong) UIScrollView *mainScroller;

@property (nonatomic, strong) NSMutableArray *mArr1;

@property (nonatomic, strong) NSMutableArray *mArr2;

@property (nonatomic, strong) NSMutableArray *mArr3;


/**
 目前正在显示的tableView
 */
@property (nonatomic, strong) UITableView *showTableView;


/**
 当前选中下标
 */
@property (nonatomic, strong) HomeModel_Theme *currentSelectedModel;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNaviBar];
    [self settings];
    
    [self requestAFTheme];
    
    [self requestRecommandAPINEWS:nil];
    
}

- (void)settings
{
    _currentSelectedModel = [HomeModel_Theme new];
    _currentSelectedModel.name = @"首页";
    
    _showTableView = _mTableView;
    
    if (!_mArr1)
    {
        _mArr1 = [NSMutableArray array];
    }
    if (!_mArr2)
    {
        _mArr2 = [NSMutableArray array];
    }
    if (!_mArr3)
    {
        _mArr3 = [NSMutableArray array];
    }
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
    label.text = @"陈鑫💕祝梦雅";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
}

- (void)testAF
{
    //http://news-at.zhihu.com/api/4/theme/13
    [AFRequest requestDataWithUrlString:@"http://news-at.zhihu.com/api/4/theme/13" Parameters:nil Method:@"GET" Proxy:nil Success:^(id result) {
        NSLog(@"result is %@",result);
    } Progress:nil Failure:^(id result) {
        
    }];
    
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
            
            //移动到该位置
            unself.mainScroller.contentOffset =  CGPointMake(itemIndex * unself.mainScroller.frame.size.width, 0);
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
    
    if (!self.mainScroller)
    {
        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH, kScreenW , kScreenH - kListBarH - 64-49)];
        self.mainScroller.bounces = NO;
        self.mainScroller.pagingEnabled = YES;
        self.mainScroller.showsHorizontalScrollIndicator = NO;
        self.mainScroller.showsVerticalScrollIndicator = NO;
        self.mainScroller.delegate = self;
        self.mainScroller.contentSize = CGSizeMake(kScreenW*5,0);
        [self.view insertSubview:self.mainScroller atIndex:0];
        
        [self addUI];

//        [self addScrollViewWithItemName:@"推荐" index:0];
//        [self addScrollViewWithItemName:@"测试" index:1];
    }
}

-(void)addScrollViewWithItemName:(NSString *)itemName index:(NSInteger)index
{
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(index * self.mainScroller.frame.size.width, 0, self.mainScroller.frame.size.width, self.mainScroller.frame.size.height)];
    scroller.backgroundColor = UIColorRGB(arc4random()%255, arc4random()%255, arc4random()%255, arc4random()%255);
    [self.mainScroller addSubview:scroller];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainScroller)
    {
        [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / self.mainScroller.frame.size.width];
    }
}

//TODO: 添加主页视图
- (void)addUI
{
    if (!_mTableView)
    {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kListBarH - 64 - 49) style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.backgroundColor = UIColorHEX(0xDFDFDF, 1);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
        imgView.image = [UIImage imageNamed:@"wallpaper_profile"];
        [_mTableView.backgroundView addSubview:imgView];
        [_mTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
        //设置默认分割线为无
        [_mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_mainScroller addSubview:_mTableView];
        _mTableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _mTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
    }
    if (!_rTableView)
    {
        _rTableView = [[UITableView alloc] initWithFrame:CGRectMake(_mTableView.right, 0, kScreenW, kScreenH - kListBarH - 64 - 49) style:UITableViewStylePlain];
        _rTableView.delegate = self;
        _rTableView.dataSource = self;
        _rTableView.backgroundColor = UIColorHEX(0xDFDFDF, 1);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
        imgView.image = [UIImage imageNamed:@"wallpaper_profile"];
        [_rTableView.backgroundView addSubview:imgView];
        [_rTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
        //设置默认分割线为无
        [_rTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_mainScroller addSubview:_rTableView];
        _rTableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _rTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
    }
}

//TODO: 添加左视图
- (void)addLeftUI
{
    if (!_lTableView)
    {
        _lTableView = [[UITableView alloc] initWithFrame:CGRectMake(_mTableView.left - kScreenW, 0, kScreenW, kScreenH - kListBarH - 64 - 49) style:UITableViewStylePlain];
        _lTableView.delegate = self;
        _lTableView.dataSource = self;
        _mTableView.backgroundColor = UIColorHEX(0xDFDFDF, 1);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
        imgView.image = [UIImage imageNamed:@"wallpaper_profile"];
        [_lTableView.backgroundView addSubview:imgView];
        [_lTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
        //设置默认分割线为无
        [_lTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_mainScroller addSubview:_lTableView];
        _lTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _lTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
    }
}

- (void)pullToRefresh
{
    [_mTableView.mj_header endRefreshing];
    [_rTableView.mj_header endRefreshing];
    [_lTableView.mj_header endRefreshing];
    if ([_currentSelectedModel.name isEqualToString:@"首页"])
    {
        [self requestRecommandAPINEWS:nil];
    }
    else
    {
        //刷新别的页面
    }
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
//    if (tableView == self.mTableView)
//    {
//    }
//    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self n_tableView:tableView cellForRowAtIndexPath:indexPath];
//    if (tableView == self.mTableView)
//    {
//    }
//    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self n_tableView:tableView didSelectRowAtIndexPath:indexPath];
//    if (tableView == self.mTableView)
//    {
//    }
}




@end
