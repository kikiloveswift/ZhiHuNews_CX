//
//  HomeModel_NewsList.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeModel_NewsList.h"

@implementation HomeModel_NewsList
- (id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super initContentWithDic:jsonDic];
    if (self)
    {
        if ([jsonDic objectForKey:@"id"])
        {
            self.id_n = [jsonDic objectForKey:@"id"];
        }
    }
    return self;

}

@end
