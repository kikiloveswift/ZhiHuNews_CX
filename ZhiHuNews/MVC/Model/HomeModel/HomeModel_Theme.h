//
//  HomeModel_Theme.h
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "BaseModel.h"

@interface HomeModel_Theme : BaseModel

@property (nonatomic, strong) NSNumber *color;

@property (nonatomic, copy) NSString *thumbnail;

@property (nonatomic, copy) NSString *description_n;

@property (nonatomic, strong) NSNumber *id_n;

@property (nonatomic, copy) NSString *name;


- (id)initContentWithDic:(NSDictionary *)jsonDic;

@end
