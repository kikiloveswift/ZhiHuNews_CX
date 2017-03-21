//
//  FMDBHandler.h
//  ZhiHuNews
//
//  Created by kong on 17/3/20.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class DetailModel;

@class HomeModel_NewsList;

@interface FMDBHandler : NSObject

+ (void)initWithDetailSQL;

//增
+ (void)insertDetailTableWith:(DetailModel *)dModel;

//增
+ (void)insertNewsListTable:(NSString *)tableName With:(HomeModel_NewsList *)hModel;

//删
+ (void)delDetailTableWith:(NSNumber *)id_n;

//查
+ (BOOL)findDetailTableWith:(NSNumber *)id_n;

@end
