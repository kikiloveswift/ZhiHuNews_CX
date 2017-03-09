//
//  HomeViewController+AF.m
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

#import "HomeViewController+AF.h"

@implementation HomeViewController (AF)

//请求主题接口
//https://news-at.zhihu.com/api/7/themes
- (void)requestThemeAPI:(ThemeData)data
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/7/themes",KURL];
    [AFRequest requestDataWithUrlString:urlString Parameters:nil Method:@"GET" Proxy:nil Success:^(id result) {
        if (data)
        {
            data(result);
        }
    } Progress:nil Failure:^(id result) {
        if (data)
        {
            data(nil);
        }
    }];
}

- (void)requestEveryDetailTheme:(NSString *)theme Data:(ThemeEveryTotalData)dataBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/7/theme/%@",KURL,theme];
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
