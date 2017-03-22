//
//  HomeScrollViewController.m
//  ZhiHuNews
//
//  Created by kong on 17/3/15.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeScrollViewController.h"
#import "HomeScrollViewController+AFRequest.h"
#import "HomeScrollViewController+SwitchLogic.h"

#import "HomeModel_Theme.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"

#define kListBarH 30
#define kArrowW 40
#define kAnimationTime 0.3


@interface HomeScrollViewController ()<ItemSelected>


@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;

@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HomeScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNaviBar];
    [self requestAFTheme];
    [self setting];
   
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
                HomeModel_Theme *sModel = [HomeModel_Theme new];
                sModel.id_n = @1;
                sModel.name = @"首页";
                [mArr addObject:sModel];
                
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
    for (HomeModel_Theme *model in self.themeArr)
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
    [self initUI];
    [self preloadPages];

}

- (void)setting
{
    if (!_pages)
    {
        _pages = [NSMutableArray array];
    }
    
    if (!_preLoadPages)
    {
        _preLoadPages = [NSMutableSet set];
    }
}

//预加载
- (void)preloadPages
{
    [_pages addObject:[[HomeListViewController alloc] initWithChannel:@1]];
    [_pages addObject:[[HomeListViewController alloc] initWithChannel:@13]];
    
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
    scrollView.contentSize = CGSizeMake(kScreenW * self.themeArr.count, 0);
    
    [self.view insertSubview:scrollView belowSubview:self.detailsList];
    self.scrollView = scrollView;
}



#pragma Mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView contentoffset x is %.1f",scrollView.contentOffset.x);
}

//滚动即将结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x/kScreenW < self.listBar.visibleItemList.count)
    {
        [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / kScreenW];
    }
}

#pragma Mark-ItemSelected
- (void)itemClickWith: (NSString *)btnTitle
{
    NSLog(@"self.top is %@",self.listBar.visibleItemList);
    NSInteger index = [self.listBar.visibleItemList indexOfObject:btnTitle];
    HomeModel_Theme *cModel; //中间Model
    HomeModel_Theme *lModel; //左边Model
    HomeModel_Theme *rModel; //右边Model
    for (HomeModel_Theme *tModel in self.themeArr)
    {
        if ([tModel.name isEqualToString:btnTitle])
        {
            cModel = tModel;
            break;
        }
    }
    NSInteger cIndex = [self.themeArr indexOfObject:cModel];
    if (cIndex == 0)
    {
        lModel = nil;
        rModel = (HomeModel_Theme *)self.themeArr[cIndex + 1];
    }
    else if(cIndex == self.listBar.visibleItemList.count - 1)
    {
        rModel = nil;
        lModel = (HomeModel_Theme *)self.themeArr[cIndex - 1];
    }
    else
    {
        lModel = (HomeModel_Theme *)self.themeArr[cIndex - 1];
        rModel = (HomeModel_Theme *)self.themeArr[cIndex + 1];
    }
    
    [self sWitchPageWithCurrentPage:cModel Left:lModel Right:rModel CurrentIndex:index];
    
    
    
}

@end
