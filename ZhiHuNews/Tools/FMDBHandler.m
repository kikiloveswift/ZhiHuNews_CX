//
//  FMDBHandler.m
//  ZhiHuNews
//
//  Created by kong on 17/3/20.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "FMDBHandler.h"

@implementation FMDBHandler

+ (void)initWithDetailSQL
{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"news.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
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
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_newsDetail (id_n integer PRIMARY KEY AUTOINCREM ENT, body text NOT NULL, title text, share_url text , css text NOT NULL, type integer , images text , image text);"];
        
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
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_newsList%@ (id_n integer PRIMARY KEY AUTOINCREM ENT, title text, type integer , images text);",@(i)];
            BOOL result1 = [db executeUpdate:sql];
            if (result1)
            {
                NSLog(@"创建表成功");
            }
        }
    }
}

@end
