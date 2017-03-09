//
//  JSONData.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "JSONData.h"

@implementation JSONData

+ (id)dicWithJsonString:(id)json
{
    if ([json isKindOfClass:[NSString class]])
    {
        json = [json dataUsingEncoding:NSUTF8StringEncoding];
        
        id jsonDic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers |NSJSONReadingMutableLeaves error:nil];
        
        return jsonDic;
    }
    
    return json;
}

+(id)dicJSONWithLocalPathName:(NSString *)pathName
{
    NSString *pathFile = [[NSBundle mainBundle]pathForResource:pathName ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:pathFile];
    
    return [JSONData dicWithJsonString:data];
    
}

+ (NSString *)stringEncodingWithString:(NSString *)string
{
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    
    NSString *str = [string stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    return str;
}

+ (NSString *)stringDecodingWithString:(NSString *)string
{
    NSString *str = [string stringByRemovingPercentEncoding];
    
    return str;
}

@end
