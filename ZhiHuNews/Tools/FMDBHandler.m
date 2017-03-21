//
//  FMDBHandler.m
//  ZhiHuNews
//
//  Created by kong on 17/3/20.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "FMDBHandler.h"
#import "DetailModel.h"
#import "HomeModel_NewsList.h"

@interface FMDBHandler()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation FMDBHandler

+ (instancetype)shareInstanceHandler
{
    static FMDBHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[FMDBHandler alloc] init];
        //1.获得数据库文件的路径
        NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
        NSString *fileName = [doc stringByAppendingPathComponent:@"news.sqlite"];
        NSLog(@"fileName********* is %@",fileName);
        handler.db = [FMDatabase databaseWithPath:fileName];
    });
    return handler;
}


+ (void)initWithDetailSQL
{
    FMDatabase *db = [FMDBHandler shareInstanceHandler].db;
    
    if ([db open])
    {
        //4.创表1
        /*
         @property (nonatomic, strong) NSNumber *id_n;  主键

         @property (nonatomic, copy) NSString *body;
         
         @property (nonatomic, copy) NSString *title;
         
         @property (nonatomic, copy) NSString *share_url;
         
         @property (nonatomic, strong) NSString *css;
         
         @property (nonatomic, strong) NSNumber *type;
         
         @property (nonatomic, strong) NSString *images;
         
         @property (nonatomic, copy) NSString *image;
         */
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_newsDetail (id integer PRIMARY KEY AUTOINCREMENT, id_n integer NOT NULL,body text NOT NULL, title text, share_url text , css text NOT NULL, type integer , images text , image text);"];
        
        if (result)
        {
            NSLog(@"创建表成功");
        }
        
        //4.创表2
        /*
         @property (nonatomic, copy) NSString *images;
         
         @property (nonatomic, strong) NSNumber *type;
         
         @property (nonatomic, strong) NSNumber *id_n;
         
         @property (nonatomic, copy) NSString *title;

         */
        for (int i = 1; i <= 13; i ++)
        {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_newsList%@ (id integer PRIMARY KEY AUTOINCREMENT, id_n integer NOT NULL, title text, type integer , images text);",@(i)];
            BOOL result1 = [db executeUpdate:sql];
            if (result1)
            {
                NSLog(@"创建表成功");
            }
        }
        [db close];
    }
}

//t_newsDetail
+ (void)insertDetailTableWith:(DetailModel *)dModel
{
//    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
//    NSString *fileName = [doc stringByAppendingPathComponent:@"news.sqlite"];
//    NSLog(@"fileName********* is %@",fileName);
//    handler.db = [FMDatabase databaseWithPath:fileName];
    FMDatabase *db = [FMDBHandler shareInstanceHandler].db;
//    FMDatabase *db = [FMDatabase databaseWithPath:fileName]
    
    if ([db open])
    {
        NSString *insertSql= [NSString stringWithFormat:
                              @"insert into t_newsDetail ('%@', '%@', '%@', '%@', '%@', '%@', '%@','%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@','%@')",
                              @"id_n",@"body",@"title", @"share_url", @"css",@"type",@"images",@"image",dModel.id_n,dModel.body,dModel.title,dModel.share_url,dModel.css,dModel.type,dModel.images,dModel.image];
        BOOL res = [db executeUpdate:insertSql];
        
        if (!res)
        {
            NSLog(@"出错");
        }
        else
        {
            NSLog(@"成功");
        }
        
        [db close];
    }
}

//删
+ (void)delDetailTableWith:(NSNumber *)id_n
{
    FMDatabase *db = [FMDBHandler shareInstanceHandler].db;
    if ([db open])
    {
        NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM t_newsDetail WHERE id_n == %@ ;",id_n];
        BOOL success = [db executeUpdate:sqlStr];
        
        if (success) {
            NSLog(@"删除数据成功!");
        }else{
            NSLog(@"删除数据失败!");
        }
        [db close];
    }
}

//查
+ (BOOL)findDetailTableWith:(NSNumber *)id_n
{
    FMDatabase *db = [FMDBHandler shareInstanceHandler].db;
    if ([db open])
    {
        //查询语句
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT id_n FROM t_newsDetail WHERE id_n = %@;",id_n];
        //执行sql查询语句(调用FMDB对象方法)
        FMResultSet *set =  [db executeQuery:sqlStr];
        while ([set next])
        {
            return YES;
        }
        [db close];
    }
    return NO;
}

//t_newsList
+ (void)insertNewsListTable:(NSString *)tableName With:(HomeModel_NewsList *)hModel
{
    FMDatabase *db = [FMDBHandler shareInstanceHandler].db;
    if ([db open])
    {
        //id_n integer NOT NULL, title text, type integer , images text
        NSString *insertSql= [NSString stringWithFormat:
                              @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')",
                              tableName, @"id_n", @"title", @"type", @"images", hModel.id_n, hModel.title, hModel.type, hModel.images];
        BOOL res = [db executeUpdate:insertSql];
        
        if (!res)
        {
            NSLog(@"出错");
        }
        else
        {
            NSLog(@"成功");
        }
        
        [db close];
    }
    
}

@end
