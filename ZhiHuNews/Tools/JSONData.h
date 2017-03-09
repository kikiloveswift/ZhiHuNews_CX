//
//  JSONData.h
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONData : NSObject

/**
 *  解析JSON
 *
 *  @param json 传入NSString或者NSData
 *
 *  @return JSONDic
 */
+ (id)dicWithJsonString:(id)json;

/**
 *  解析本地JSON文件
 *
 *  @param pathName 文件名
 *
 *  @return JSON字典
 */
+ (id)dicJSONWithLocalPathName:(NSString *)pathName;

/**
 *  URL编码
 *
 *  @param string 普通字符串
 *
 *  @return 编码字符串
 */
+ (NSString *)stringEncodingWithString:(NSString *)string;

/**
 *  URL解码
 *
 *  @param string 编码字符串
 *
 *  @return 普通字符串
 */
+ (NSString *)stringDecodingWithString:(NSString *)string;

@end
