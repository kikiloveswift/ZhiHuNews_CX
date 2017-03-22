//
//  HomeScrollViewController+AFRequest.m
//  ZhiHuNews
//
//  Created by kong on 17/3/22.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeScrollViewController+AFRequest.h"

@implementation HomeScrollViewController (AFRequest)

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

@end
