//
//  HomeRootViewController+AF.h
//  ZhiHuNews
//
//  Created by kong on 17/3/17.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

typedef void(^ThemeData)(id obj);
#import "HomeRootViewController.h"

@interface HomeRootViewController (AF)

//请求全部主题数据
- (void)requestThemeAPI:(ThemeData)data;

@end
