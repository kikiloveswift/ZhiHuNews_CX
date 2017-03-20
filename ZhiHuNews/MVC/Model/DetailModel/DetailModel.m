//
//  DetailModel.m
//  ZhiHuNews
//
//  Created by kong on 17/3/20.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

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
