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
        if ([jsonDic objectForKey:@"images"] && [[jsonDic objectForKey:@"images"] isKindOfClass:[NSArray class]])
        {
            NSArray *images = (NSArray *)[jsonDic objectForKey:@"images"];
            if (images.count > 0)
            {
                self.images = images[0];
            }
        }
    }
    return self;

}

@end
