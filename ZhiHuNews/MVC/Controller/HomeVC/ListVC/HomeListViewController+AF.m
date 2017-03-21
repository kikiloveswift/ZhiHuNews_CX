//
//  HomeListViewController+AF.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

/*
 推荐接口
 https://news-at.zhihu.com/api/7/stories/latest?client=0
 
 //昨天推荐的
 https://news-at.zhihu.com/api/7/stories/before/20170308?client=0
 
 //体育日报
 https://news-at.zhihu.com/api/7/theme/8
 
 //文章
 https://news-at.zhihu.com/api/7/story/7259643
 
 //点赞
 https://news-at.zhihu.com/api/7/story-extra/7259643
 
 */

#import "HomeListViewController+AF.h"

@implementation HomeListViewController (AF)

//请求首页 推荐新闻
//https://news-at.zhihu.com/api/7/stories/before/20170308?client=0
//https://news-at.zhihu.com/api/7/stories/latest?client=0
- (void)requestRecommandAPI:(RecommndData)recommandBlock Params:(NSString *)params Theme:(NSString *)theme
{
    
    NSString *urlString = nil;
    if (theme.integerValue == 1)
    {
        //首页
        if (params)
        {
            urlString = [NSString stringWithFormat:@"%@/api/7/stories/before/%@?client=0",KURL,params];
        }
        else
        {
            urlString = [NSString stringWithFormat:@"%@/api/7/stories/latest",KURL];
        }
    }
    else
    {
        if (params)
        {
            urlString = [NSString stringWithFormat:@"%@/api/7/theme/%@/before/%@",KURL,theme,params];
        }
        else
        {
            urlString = [NSString stringWithFormat:@"%@/api/7/theme/%@",KURL,theme];
        }
    }
    
    
    [AFRequest requestDataWithUrlString:urlString Parameters:nil Method:@"GET" Proxy:nil Success:^(id result) {
        if (recommandBlock)
        {
            recommandBlock(result);
        }
    } Progress:nil Failure:^(id result) {
        if (recommandBlock)
        {
            recommandBlock(nil);
        }
    }];
}



//https://news-at.zhihu.com/api/7/theme/8
//https://news-at.zhihu.com/api/7/theme/8/before/7082061
- (void)requestEveryDetailTheme:(NSString *)theme Data:(ThemeEveryTotalData)dataBlock Params:(NSString *)params
{
    NSString *urlString = nil;
    if (params)
    {
        urlString = [NSString stringWithFormat:@"%@/api/7/theme/%@/before/%@",KURL,theme,params];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@/api/7/theme/%@",KURL,theme];
    }
    [AFRequest requestDataWithUrlString:urlString Parameters:nil Method:@"GET" Proxy:nil Success:^(id result) {
        if (dataBlock)
        {
            dataBlock(result);
        }
    } Progress:nil Failure:^(id result) {
        if (dataBlock)
        {
            dataBlock(nil);
        }
    }];
}

@end
