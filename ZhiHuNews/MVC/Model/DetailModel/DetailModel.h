//
//  DetailModel.h
//  ZhiHuNews
//
//  Created by kong on 17/3/20.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "BaseModel.h"

@interface DetailModel : BaseModel

@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *share_url;

@property (nonatomic, strong) NSArray *css;

@property (nonatomic, strong) NSNumber *id_n;

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, copy) NSString *image;

- (id)initContentWithDic:(NSDictionary *)jsonDic;

@end
