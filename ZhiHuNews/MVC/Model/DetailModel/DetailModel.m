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
        if ([[jsonDic objectForKey:@"css"] isKindOfClass:[NSArray class]])
        {
            NSArray *cssArr = [jsonDic objectForKey:@"css"];
            if (cssArr.count > 0)
            {
                self.css = cssArr[0];
            }
        }
        if ([[jsonDic objectForKey:@"images"] isKindOfClass:[NSArray class]])
        {
            NSArray *imagesArr = [jsonDic objectForKey:@"images"];
            if (imagesArr.count > 0)
            {
                self.images = imagesArr[0];
            }
        }
        if ([jsonDic objectForKey:@"body"])
        {
            NSString *str = [jsonDic objectForKey:@"body"];
            NSString *rstr = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            self.body = rstr;
        }
    }
    return self;
}

@end
