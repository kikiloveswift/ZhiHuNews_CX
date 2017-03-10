//
//  HomeViewController+AF.h
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

typedef void(^RecommndData)(id obj);
typedef void(^ThemeData)(id obj);
typedef void(^ThemeEveryTotalData)(id obj);
#import "HomeViewController.h"

@interface HomeViewController (AF)

//请求首页推荐新闻
- (void)requestRecommandAPI:(RecommndData)recommandBlock Params:(NSString *)params;

//请求全部主题数据
- (void)requestThemeAPI:(ThemeData)data;

//请求每个主题下面每条数据
- (void)requestEveryDetailTheme:(NSString *)theme Data:(ThemeEveryTotalData)dataBlock;

@end
