//
//  DetailViewController.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/17.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

typedef void(^BuildThen)();

#import "DetailViewController.h"
#import "DetailModel.h"

@interface DetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    CGRect initialFrame;
    
    
}

//是否有头部图片
@property (nonatomic, assign) BOOL hasTopView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIWebView *webView;

/**
 HTML - Body
 */
@property (nonatomic, copy) NSString *bodyText;


/**
 HTML - 样式
 */
@property (nonatomic, copy) NSString *cssStyle;


/**
 分享链接
 */
@property (nonatomic, copy) NSString *shartURL;


/**
 分享标题
 */
@property (nonatomic, copy) NSString *shareTitle;


/**
 tag
 */
@property (nonatomic, strong) NSNumber *id_n;


/**
 存储Model的Arr
 */
@property (nonatomic, strong) NSArray *dataArr;


@end

@implementation DetailViewController


- (instancetype)initWithtag:(NSNumber *)tag
{
    self = [super init];
    if (self)
    {
        _id_n = tag;
    }
    return self;
}
- (void)requestAPI:(BuildThen)buildThen
{
    [AFRequest requestDataWithUrlString:[NSString stringWithFormat:@"%@/api/4/story/%@",KURL,_id_n] Parameters:nil Method:@"GET" Proxy:nil Success:^(id result)
    {
        if ([result isKindOfClass:[NSDictionary class]] && result)
        {
            NSDictionary *dataDic = (NSDictionary *)result;
            DetailModel *dModel = [[DetailModel alloc] initContentWithDic:dataDic];
            NSMutableArray *mArr = [NSMutableArray array];
            [mArr addObject:dModel];
            _dataArr = mArr;
            !buildThen ?: buildThen();
        }
        
    } Progress:nil Failure:^(id result) {
        !buildThen ?: buildThen();
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    self.fd_prefersNavigationBarHidden = YES;
    [SVProgressHUD showWithStatus:@"loading..."];
    if ([self didHasFav])
    {
        self.favBtn.selected = YES;
        [self.favBtn setImage:[UIImage imageNamed:@"news_fav"] forState:UIControlStateSelected];
    }
    else
    {
        self.favBtn.selected = NO;
        [self.favBtn setImage:[UIImage imageNamed:@"news_disfav"] forState:UIControlStateNormal];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)initUI
{
    //初始化WebView
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 49)];
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    [_webView scalesPageToFit];
    _webView.scrollView.bounces = YES;
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    //初始化imgView
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 220)];
    _imgView.hidden = YES;
    _imgView.contentMode = UIViewContentModeCenter;
    _imgView.clipsToBounds = YES;
    [_imgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [_webView.scrollView addSubview:_imgView];
    __weak typeof(self) weakself = self;
    [self requestAPI:^{
       
        dispatch_async(dispatch_get_main_queue(), ^{
            //TODO: 查询数据库 是否收藏此条新闻
            
            NSString *bodyStr = nil;
            NSString *cssStyle = nil;
            if (weakself.dataArr && weakself.dataArr.count > 0)
            {
                if ([weakself.dataArr[0] isKindOfClass:[DetailModel class]])
                {
                    DetailModel *dModel = weakself.dataArr[0];
                    bodyStr = dModel.body;
                    cssStyle = dModel.css;

                    if (dModel.image)
                    {
                        weakself.hasTopView = YES;
                        [weakself.imgView sd_setImageWithURL:[NSURL URLWithString:dModel.image] placeholderImage:[UIImage imageNamed:@"wallpaper_profile"]];
                        weakself.imgView.hidden = NO;
                    }
                }
            }
            NSString *formatString = [NSString stringWithFormat:
                                      @"<!DOCTYPE html><html><head lang=\"zh\"><meta charset=\"UTF-8\"> <link rel=\"stylesheet\" type=\"text/css\" href=\"%@\">"
                                      "<body>"
                                      "<p>%@</p>"
                                      "</body></html>", cssStyle,bodyStr];
            
            [weakself.webView loadHTMLString:formatString baseURL:nil];
        });
    }];
}


#pragma Mark -UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestStr = request.URL.absoluteString;
    if ([requestStr.lowercaseString containsString:@"www.zhihu.com"])
    {
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

#pragma Mark-UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_hasTopView)
    {
        CGRect f = _imgView.frame;
        f.size.width = kScreenW;
        _imgView.frame  = f;
        
        if(scrollView.contentOffset.y < 0)
        {
            CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
            
            initialFrame.origin.y = - offsetY * 1;
            initialFrame.origin.x = - offsetY / 2;
            
            initialFrame.size.width  = kScreenW + offsetY;
            initialFrame.size.height = 220 + offsetY;
            
            _imgView.frame = initialFrame;
        }
    }
}

//TODO: 查询数据库 是否已收藏
- (BOOL)didHasFav
{
    return [FMDBHandler findDetailTableWith:_id_n];
}

//收藏此条
- (void)favNews
{
    self.favBtn.selected = YES;
    [self.favBtn setImage:[UIImage imageNamed:@"news_fav"] forState:UIControlStateSelected];
    if (self.dataArr && self.dataArr.count > 0)
    {
        DetailModel *dModel = (DetailModel *)self.dataArr[0];
        [FMDBHandler insertDetailTableWith:dModel];
    }
}

//取消收藏
- (void)disFavNews
{
    self.favBtn.selected = NO;
    [self.favBtn setImage:[UIImage imageNamed:@"news_disfav"] forState:UIControlStateNormal];
    if (self.dataArr && self.dataArr.count > 0)
    {
        DetailModel *dModel = (DetailModel *)self.dataArr[0];
        [FMDBHandler delDetailTableWith:dModel.id_n];
    }
    
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)favAction:(id)sender
{
    self.favBtn.selected = !self.favBtn.selected;
    
    if (self.favBtn.selected)
    {
        [self favNews];
    }
    else
    {
        [self disFavNews];
    }
}

- (void)dealloc
{
    NSLog(@"dead");
}
- (IBAction)shareAction:(id)sender
{
    
}
- (IBAction)nextPageAction:(id)sender
{
    
}

@end
