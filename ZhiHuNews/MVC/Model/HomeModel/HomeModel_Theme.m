//
//  HomeModel_Theme.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeModel_Theme.h"

@implementation HomeModel_Theme

- (id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super initContentWithDic:jsonDic];
    if (self)
    {
        //处理关键字段
        if ([jsonDic objectForKey:@"description"])
        {
            self.description_n = [jsonDic objectForKey:@"description"];
        }
        
        //处理关键字段
        if ([jsonDic objectForKey:@"id"])
        {
            self.id_n = [jsonDic objectForKey:@"id"];
        }
    }
    return self;
}
@end
