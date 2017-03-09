//
//  HomeModel_NewsList.h
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "BaseModel.h"

@interface HomeModel_NewsList : BaseModel

@property (nonatomic, copy) NSString *images;

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSNumber *id_n;

@property (nonatomic, copy) NSString *title;

- (id)initContentWithDic:(NSDictionary *)jsonDic;

@end
