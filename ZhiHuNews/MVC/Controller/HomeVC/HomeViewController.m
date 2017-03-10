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

@interface HomeViewController () <UIScrollViewDelegate, ItemSelected, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;

@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic,strong) UIScrollView *mainScroller;

@end

@implementation HomeViewController

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
    label.text = @"陈鑫喜欢祖梦雅不给老表学技术";
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
    for (HomeModel_Theme *model in _themeArr)
    {
        if (listTop.count < 6)
        {
            [listTop addObject:model.name];
        }
        else
        {
            [listBottom addObject:model.name];
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
        
        [self addScrollViewWithItemName:@"推荐" index:0];
        [self addScrollViewWithItemName:@"测试" index:1];
    }
}

-(void)addScrollViewWithItemName:(NSString *)itemName index:(NSInteger)index
{
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(index * self.mainScroller.frame.size.width, 0, self.mainScroller.frame.size.width, self.mainScroller.frame.size.height)];
    scroller.backgroundColor = UIColorRGB(arc4random()%255, arc4random()%255, arc4random()%255, arc4random()%255);
    [self.mainScroller addSubview:scroller];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / self.mainScroller.frame.size.width];
}

//添加主页视图
- (void)addUI
{
    if (!_mTableView)
    {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kScreenW, kScreenH - kListBarH - 64 - 49) style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        [_mTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
        //设置默认分割线为无
        [_mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_mainScroller addSubview:_mTableView];
    }
    if (!_rTableView)
    {
        _rTableView = [[UITableView alloc] initWithFrame:CGRectMake(_mTableView.right, 30, kScreenW, kScreenH - kListBarH - 64 - 49) style:UITableViewStylePlain];
        _rTableView.delegate = self;
        _rTableView.dataSource = self;
        [_rTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
        //设置默认分割线为无
        [_rTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_mainScroller addSubview:_rTableView];
    }
}

//添加左视图
- (void)addLeftUI
{
    if (!_lTableView)
    {
        _lTableView = [[UITableView alloc] initWithFrame:CGRectMake(_mTableView.left - kScreenW, 30, kScreenW, kScreenH - kListBarH - 64 - 49) style:UITableViewStylePlain];
        _lTableView.delegate = self;
        _lTableView.dataSource = self;
        [_lTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
        //设置默认分割线为无
        [_lTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_mainScroller addSubview:_lTableView];
    }
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
    //TODO: 请求网络
    [self requestEveryDetailTheme:[NSString stringWithFormat:@"%@",s_model.id_n] Data:^(id obj)
    {
        //TODO: loading
        
    }];
}

#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mTableView)
    {
        return [self n_tableView:tableView numberOfRowsInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mTableView)
    {
        return [self n_tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mTableView)
    {
        [self n_tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}




@end
